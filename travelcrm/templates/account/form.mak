<%namespace file="../note/common.mak" import="note_selector"/>
<%namespace file="../task/common.mak" import="task_selector"/>
<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"name"), True, "name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("name", item.name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"account type"), True, "account_type")}
                    </div>
                    <div class="ml15">
                        ${h.fields.accounts_types_combobox_field(item.account_type.key if item else None)}
                        ${h.common.error_container(name='account_type')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"currency"), True, "currency_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.currencies_combobox_field(
                            request, item.currency_id if item else None,
                            show_toolbar=(not readonly if readonly else True)
                        )}
                        ${h.common.error_container(name='currency_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"display text"), True, "display_text")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("display_text", item.display_text if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='display_text')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                         ${h.tags.title(_(u"description"), False, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("descr", item.descr if item else None, class_="easyui-textbox w20", data_options="multiline:true,height:80")}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
                        values=([note.id for note in item.resource.notes] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${task_selector(
                        values=([task.id for task in item.resource.tasks] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
