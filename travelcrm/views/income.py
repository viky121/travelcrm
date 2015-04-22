# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.income import Income
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.income import IncomeQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.bl.incomes import make_payment

from ..forms.income import (
    IncomeSchema, 
    IncomeSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.income.IncomeResource',
)
class IncomeView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/incomes/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = IncomeSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = IncomeQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            income = Income.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': income.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Income"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Income')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = IncomeSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            income = Income(
                invoice_id=controls.get('invoice_id'),
                resource=self.context.create_resource()
            )
            income.cashflows = make_payment(
                self.context,
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                income.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                income.resource.tasks.append(task)
            DBSession.add(income)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='edit'
    )
    def edit(self):
        income = Income.get(self.request.params.get('id'))
        return {'item': income, 'title': _(u'Edit Income')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = IncomeSchema().bind(request=self.request)
        income = Income.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            income.rollback()
            income.invoice_id = controls.get('invoice_id')
            income.cashflows = make_payment(
                self.context,
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            income.resource.notes = []
            income.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                income.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                income.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/incomes/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Income Payments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Income.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
