<%namespace file="../common/search.mak" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _s_id = "s-%s" % _id    
%>
<div class="easyui-panel unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    "
    title="${_(u'Income Payments')}">
    <table class="easyui-datagrid"
    	id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var dg = $(this);
                $.each($('#${_s_id}, #${_tb_id} .searchbar').find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'date',sortable:true,width:80">${_(u"date")}</th>
            <th data-options="field:'account_name',sortable:true,width:150">${_(u"account name")}</th>
            <th data-options="field:'customer',sortable:true,width:150">${_(u"customer")}</th>
            <th data-options="field:'resource_type',sortable:true,width:150">${_(u"source")}</th>
            <th data-options="field:'sum',sortable:true,width:100,formatter:function(value, row, index){return row.currency + ' ' + value;}">${_(u"sum")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl45">
            % if _context.has_permision('add'):
            <a href="#" class="button primary _action" 
                data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add')}'">
                <span class="fa fa-plus"></span>${_(u'Add New')}
            </a>
            % endif
            <div class="button-group">
                % if _context.has_permision('edit'):
                <a href="#" class="button _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit')}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit')}
                </a>
                % endif
                % if _context.has_permision('delete'):
                <a href="#" class="button danger _action" 
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                    <span class="fa fa-times"></span>${_(u'Delete')}
                </a>
                % endif
            </div>
        </div>
        <div class="ml45 tr">
            <div class="search">
                ${searchbar(_id, _s_id, prompt=_(u'Enter customer name'))}
                <div class="advanced-search tl hidden" id = "${_s_id}">
                    <div>
                        ${h.tags.title(_(u"invoice"))}
                    </div>
                    <div>
                        ${h.fields.invoices_combobox_field(request, None, 'invoice_id', show_toolbar=False)}
                    </div>
		            <div class="mt05">
		                ${h.tags.title(_(u"account"))}
		            </div>
		            <div>
		                ${h.fields.accounts_combobox_field(request, None, 'account_id', show_toolbar=False, structure_id=None)}
		            </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"currency"))}
                    </div>
                    <div>
                        ${h.fields.currencies_combobox_field(request, None, 'currency_id', show_toolbar=False)}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"payment date"))}
                    </div>
                    <div>
                        ${h.fields.date_field(None, "payment_from")}
                        <span class="p1">-</span>
                        ${h.fields.date_field(None, "payment_to")}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"sum range"))}
                    </div>
                    <div>
                        ${h.tags.text('sum_from', None, class_="easyui-textbox w10 easyui-numberbox", data_options="min:0,precision:0")}
                        <span class="p1">-</span>
                        ${h.tags.text('sum_to', None, class_="easyui-textbox w10 easyui-numberbox", data_options="min:0,precision:0")}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"updated"))}
                    </div>
                    <div>
                        ${h.fields.date_field(None, "updated_from")}
                        <span class="p1">-</span>
                        ${h.fields.date_field(None, "updated_to")}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"modifier"))}
                    </div>
                    <div>
                        ${h.fields.employees_combobox_field(request, None, 'modifier_id', show_toolbar=False)}
                    </div>
                    <div class="mt1">
                        <div class="button-group minor-group">
                            <a href="#" class="button _advanced_search_submit">${_(u"Find")}</a>
                            <a href="#" class="button" onclick="$(this).closest('.advanced-search').hide();">${_(u"Close")}</a>
                            <a href="#" class="button danger _advanced_search_clear">${_(u"Clear")}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
