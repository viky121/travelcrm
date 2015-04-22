<div class="dl45 easyui-dialog"
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
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"licence num"), True, "licence_num")}
            </div>
            <div class="ml15">
                ${h.tags.text("licence_num", item.licence_num if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='licence_num')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"date from"), True, "date_from")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date_from if item else None, "date_from")}
                ${h.common.error_container(name='date_from')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"date to"), True, "date_to")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date_to if item else None, "date_to")}
                ${h.common.error_container(name='date_to')}
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
