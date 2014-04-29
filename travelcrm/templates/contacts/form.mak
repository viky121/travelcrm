<div class="dl40 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"contact type"), True, "contact_type")}
            </div>
            <div class="ml15">
                ${h.fields.contact_type_combobox_field(item.contact_type if item else None, 'contact_type')}
                ${h.common.error_container(name='contact_type')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"contact"), True, "contact")}
            </div>
            <div class="ml15">
                ${h.tags.text("contact", item.contact if item else None, class_="text w20")}
                ${h.common.error_container(name='contact')}
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