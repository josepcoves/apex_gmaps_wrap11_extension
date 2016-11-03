set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.4.00.12'
,p_default_workspace_id=>13707805413010735447
,p_default_application_id=>528922
,p_default_owner=>'JOSEPCOVES'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/nl_warp11_apex_gmaps
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(71172791097624928973)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'NL.WARP11.APEX.GMAPS'
,p_display_name=>'Warp11 GMaps Item (Ampliado JCoves)'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'function render_gmap(',
'   p_item                IN APEX_PLUGIN.T_PAGE_ITEM,',
'   p_plugin              IN APEX_PLUGIN.T_PLUGIN,',
'   p_value               IN VARCHAR2,',
'   p_is_readonly         IN BOOLEAN,',
'   p_is_printer_friendly IN boolean',
'   ) return apex_plugin.t_page_item_render_result',
'is',
'  t_divid                   varchar(32767)   := p_item.name;',
'  t_streetview              varchar2(5)      := p_item.attribute_01;',
'  t_navigationControl       varchar2(5)      := p_item.attribute_02;',
'  t_maptype                 varchar2(32767)  := p_item.attribute_03;',
'  t_mapTypeControl          varchar2(5)      := p_item.attribute_04;',
'  t_mapTypeControl_position varchar2(32767)  := p_item.attribute_05;',
'  t_mapTypeControl_style    varchar2(32767)  := p_item.attribute_06;',
'  t_address                 varchar2(32767)  := p_item.attribute_07;',
'  t_markers_address         varchar2(32767); --  := p_item.attribute_08;',
'  t_markers_html_content    clob;--varchar2(32767); --  := p_item.attribute_09;',
'  --Added by JCoves',
'  t_pin_icon                varchar2(32767); -- := p_item.attribute_08;',
'  t_latlong                 varchar2(32767); -- := p_item.attribute_09;',
'  t_group                   varchar2(32767);--  := p_item.attribute_11;',
'  --End JCoves',
'  t_zoom                    varchar2(32767)  := p_item.attribute_10;',
'  ',
'  t_title                   varchar2(32767);',
'  t_infovisible             varchar2(5);',
'  t_column_value_list       apex_plugin_util.t_column_value_list;',
'  function b(p_booleanval in varchar2) return varchar2 is',
'  begin',
'    case p_booleanval',
'      when ''Y'' then return ''true'';',
'      else return ''false'';',
'    end case;',
'  end;',
'  ',
'  /*function do_subststring(p_htmlcontent in varchar2) return varchar2 is',
'    t_retval varchar2(32767) := p_htmlcontent;',
'  begin',
'    t_retval := replace(t_retval, ''#APP_IMAGES''       || ''#'', v(''APP_IMAGES''));',
'    t_retval := replace(t_retval, ''#WORKSPACE_IMAGES'' || ''#'', v(''WORKSPACE_IMAGES''));',
'    return t_retval;',
'  end do_subststring;*/',
'  ',
'  function do_subststring(p_htmlcontent in clob) return clob is',
'    t_retval clob := p_htmlcontent;',
'  begin',
'    t_retval := replace(t_retval, ''#APP_IMAGES''       || ''#'', v(''APP_IMAGES''));',
'    t_retval := replace(t_retval, ''#WORKSPACE_IMAGES'' || ''#'', v(''WORKSPACE_IMAGES''));',
'    return t_retval;',
'  end do_subststring;',
'  ',
'begin',
'  -- include jscript:',
'  apex_javascript.add_library(',
'      --p_name      => ''jquery.gomap-1.2.2.min'',',
'      p_name      => ''jquery.gomap-1.3.3.min'',',
'      p_directory => p_plugin.file_prefix,',
'      p_version   => NULL);',
'  t_navigationControl := b(t_navigationControl);',
'  t_mapTypeControl    := b(t_mapTypeControl);',
'  t_streetview        := b(t_streetview);',
'  ',
'  --htp.p(''<script language="javascript">'');',
'  --htp.p('' alert("'' || V(''APP_IMAGES'') || ''");'');',
'  --htp.p(''</script>'');',
'',
'  t_column_value_list := apex_plugin_util.get_data (',
'                             p_sql_statement  => p_item.lov_definition,',
'                             p_min_columns    => 4,',
'                             p_max_columns    => 7, ',
'                             p_component_name => p_item.id); --Modified by JCoves (from 4 to 7)',
'  ',
'  htp.p(''  <script type="text/javascript" src="//maps.google.com/maps/api/js?sensor=false"></script>'');',
'--  htp.p(''  <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>''); --20141103 JCoves: Cal afegir una opció per suportar https sinó no funciona',
'  htp.p(''<div id="'' || t_divid || ''" style="width: 300px; height: 300px; background-color: green;"></div>'');',
'  htp.p(''<script language="javascript">'');',
'  --htp.p(''  <!--'');',
'  htp.p('' function loadMap(){''); -- JCoves 20160519',
'  --htp.p(''    $(function() {''); -- JCoves 20160519',
'  htp.p(''      $("#'' || t_divid || ''").goMap({'');',
'  htp.p(''        ''||p_item.element_attributes); --JCoves Additional attributes available',
'  htp.p(''        streetViewControl: '' || t_streetview || '','');',
'  htp.p(''        navigationControl: '' || t_navigationControl || '','');',
'  htp.p(''        maptype: '''''' || t_maptype || '''''','');',
'  htp.p(''        mapTypeControl: '' || t_mapTypeControl || '','');',
'  htp.p(''        mapTypeControlOptions: {'');',
'  htp.p(''          position: '''''' || t_mapTypeControl_position || '''''','');',
'  htp.p(''          style: '''''' || t_mapTypeControl_style || '''''''');',
'  htp.p(''        },'');',
'  htp.p(''        address: '''''' || v(t_address) || '''''','');',
'  htp.p(''        markers: ['');',
'  ',
'  for i in 1 .. t_column_value_list(1).count /* label */',
'    loop',
'      t_markers_address      := t_column_value_list(1)(i);',
'      t_title                := t_column_value_list(2)(i);',
'      t_markers_html_content := t_column_value_list(3)(i);',
'  ',
'      t_infovisible          := case ',
'                                when lower(t_column_value_list(4)(i)) not in (''false'', ''true'') then ''false''',
'                                else lower(t_column_value_list(4)(i))',
'                                end;',
'      --Added by JCoves',
'      if (t_column_value_list.EXISTS(5)) then',
'        t_pin_icon             := do_subststring(t_column_value_list(5)(i));',
'      end if;',
'      if (t_column_value_list.EXISTS(6)) then',
'        t_latlong              := t_column_value_list(6)(i);',
'      end if;',
'      if (t_column_value_list.EXISTS(7)) then',
'        t_group              := t_column_value_list(7)(i);',
'      end if;',
'      --End JCoves',
'      htp.p(''          {'');',
'',
'      --Modified by JCoves      ',
'      -- Original --htp.p(''              address: '''''' || t_markers_address || '''''','');',
'      if (t_latlong is not null) then',
'           htp.p(''              longitude:''||rtrim(ltrim(substr(t_latlong,instr(t_latlong,'','')+1)))||'','');',
'           htp.p(''              latitude:''||rtrim(ltrim(substr(t_latlong,0,instr(t_latlong,'','')-1)))||'','');',
'      else ',
'           htp.p(''              address: '''''' || t_markers_address || '''''','');',
'      end if;',
'      --End JCoves',
'      htp.p(''              title: ''''''   || t_title           || '''''','');',
'      --Added by JCoves',
'      if (t_group is not null) then',
'         htp.p(''              group:"''||t_group||''",'');',
'      end if;',
'      if (t_pin_icon is not null) then',
'        htp.p(''              icon:"''||t_pin_icon||''",'');',
'        --htp.p(''              strokeColor: "red",'');',
'      end if;',
'      --End JCoves',
'      htp.p(''              html: {'');',
'      htp.p(''                content: ''''<div style="width: '' || to_char(to_number(p_item.element_width)-200) || ''px;">'' || replace(/*do_subststring*/(t_markers_html_content), '''''''', ''\'''''') || ''</div>'''','');',
'      htp.p(''                popup: '' || t_infovisible || '''');',
'        htp.p(''              }'');',
'      if i = t_column_value_list(1).count then',
'        htp.p(''          }'');',
'      else ',
'        htp.p(''          },'');',
'      end if;',
'    end loop;',
'    ',
'  htp.p(''        ],'');',
'  htp.p(''        zoom: '' || t_zoom );--|| '','');',
'  htp.p(''      });'');',
'  htp.p(''      $("#'' || t_divid || ''").height('' || p_item.element_height || '');'');',
'  htp.p(''      $("#'' || t_divid || ''").width('' || p_item.element_width || '');'');',
'  --htp.p(''    });'');-- JCoves 20160519',
'  htp.p('' }'');-- JCoves 20160519',
'  htp.p(''document.addEventListener("DOMContentLoaded", function(event) { loadMap() });'');',
' --htp.p(''    $(document).ready(loadMap()); ''); -- JCoves 20160519',
'  --htp.p(''  -->'');',
'  htp.p(''</script>'');/**/',
'  return null;',
'end render_gmap;'))
,p_render_function=>'render_gmap'
,p_standard_attributes=>'VISIBLE:ELEMENT:WIDTH:HEIGHT:ELEMENT_OPTION:LOV:LOV_REQUIRED'
,p_sql_min_column_count=>4
,p_sql_max_column_count=>6
,p_sql_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'select address',
',      title',
',      markerhtml',
',      infobaxvisible -- true/false',
',      icon --Image URL',
',      latlong --Latitude, longitude separated by comma',
',      group --Icon group in order to execute 	$.goMap.showHideMarkerByGroup(group, true);',
'from WARP_ADDRESSES t'))
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'	Updated by JCoves</p>',
'<p>',
'	================</p>',
'',
'<strong>Last update: 03/11/2016. Version 1.2 new features:</strong>',
'<ul>',
'<li>Corrected error with Universal Theme to prevent map provperly. No need to call loadMap function as previosly. Seems to work at all browsers except IE8, in its case you need to create a Dynamic Action to fire loadMap() function.</li>',
'</ul>',
'<strong>update: 10/07/2015. Version 1.1 new features:</strong>',
'<p><stong>IMPORTANT Note for Universal Theme:</strong> In case you are using Universal Theme, you need to create a Dynamic Action on Page load with following JavaScript code, otherwise plugin will render a green square and won''t work:',
'<p><i>if ($.isFunction(''loadMap'')) loadMap();</i></p>',
'</p>',
'<ul>',
'<li>Upgraded inner gomaps plugin to version 1.3.3 (includes Googlemaps v3)</li>',
'<li>Added possibility to group plugins using new sql column group</li>',
'</ul>',
'<strong>Version 1.0 new features:</strong>',
'<p>',
'	Added the following attributes at SQL Query:</p>',
'<p>',
'	&nbsp;</p>',
'<ul>',
'	<li>',
'		Icon: Use custom pin image, specify the image URL&nbsp;</li>',
'	<li>',
'		Latlong: Specify Latitude and Longitude instead of address to increase performance on multiple markers. Ex:&nbsp;41.380268, 2.190475</li>',
'</ul>',
'<p>',
'	&nbsp;</p>',
'<p>',
'	&nbsp;</p>',
'<p>',
'	================</p>',
'<p>',
'	The Warp11 GMaps plugin provides an easy way of incorporating a Google Map on your page.</p>',
'<p>',
'	The plugin was created bij Richard &amp; Sergei Martens of the Warp 11 Center of Excellence.</p>',
'<p>',
'	The plugin uses a number of parameters / settings:</p>',
'<ul>',
'	<li>',
'		StreetViewControl</li>',
'	<li>',
'		navigationControl</li>',
'	<li>',
'		maptype</li>',
'	<li>',
'		mapTypeControl</li>',
'	<li>',
'		mapTypeControl_position</li>',
'	<li>',
'		mapTypeControl_style</li>',
'	<li>',
'		address (page item)</li>',
'	<li>',
'		zoom (integer)</li>',
'</ul>',
'<p>',
'	It is essential that the page-items mentioned in the settings are rendered <strong>before</strong> then gmaps plugin. Otherwise the plugin cannot read the values. The page items can be of the <em>hidden</em> type.</p>',
'<p>',
'	Width and Hight of the page-item are used to create the map.</p>',
'<p>',
'	More information can be found at <a href="http://apex.warp11.nl" target="_blank">http://apex.warp11.nl</a></p>'))
,p_version_identifier=>'1.7'
,p_about_url=>'http://www.relational.es'
,p_plugin_comment=>'Thanks to http://www.pittss.lv/jquery/gomap/ for the jQuery plugin.'
,p_files_version=>2
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71176071002040349299)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'StreetViewControl'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Do you want the little puppet to appear on the map?'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172794528099937826)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'navigationControl'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172801102735949387)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'maptype'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'HYBRID'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172802207237950633)
,p_plugin_attribute_id=>wwv_flow_api.id(71172801102735949387)
,p_display_sequence=>10
,p_display_value=>'HYBRID'
,p_return_value=>'HYBRID'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172802709661951415)
,p_plugin_attribute_id=>wwv_flow_api.id(71172801102735949387)
,p_display_sequence=>20
,p_display_value=>'ROADMAP'
,p_return_value=>'ROADMAP'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172803112431952142)
,p_plugin_attribute_id=>wwv_flow_api.id(71172801102735949387)
,p_display_sequence=>30
,p_display_value=>'SATELLITE'
,p_return_value=>'SATELLITE'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172804014163952714)
,p_plugin_attribute_id=>wwv_flow_api.id(71172801102735949387)
,p_display_sequence=>40
,p_display_value=>'TERRAIN'
,p_return_value=>'TERRAIN'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172805825245955876)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'mapTypeControl'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172807503558959039)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'mapTypeControl_position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172808407368960132)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>10
,p_display_value=>'TOP'
,p_return_value=>'TOP'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172814310138960933)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>20
,p_display_value=>'TOP_LEFT'
,p_return_value=>'TOP_LEFT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172814911870961460)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>30
,p_display_value=>'TOP_RIGHT'
,p_return_value=>'TOP_RIGHT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172815313601961967)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>40
,p_display_value=>'BOTTOM'
,p_return_value=>'BOTTOM'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172815716025962632)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>50
,p_display_value=>'BOTTOM_LEFT'
,p_return_value=>'BOTTOM_LEFT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172816117411963048)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>60
,p_display_value=>'BOTTOM_RIGHT'
,p_return_value=>'BOTTOM_RIGHT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172816519835963754)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>70
,p_display_value=>'LEFT'
,p_return_value=>'LEFT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172816922259964513)
,p_plugin_attribute_id=>wwv_flow_api.id(71172807503558959039)
,p_display_sequence=>80
,p_display_value=>'RIGHT'
,p_return_value=>'RIGHT'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172820216634981739)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'mapTypeControl_style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'DEFAULT'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172820818711982342)
,p_plugin_attribute_id=>wwv_flow_api.id(71172820216634981739)
,p_display_sequence=>10
,p_display_value=>'DEFAULT'
,p_return_value=>'DEFAULT'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172822229101985411)
,p_plugin_attribute_id=>wwv_flow_api.id(71172820216634981739)
,p_display_sequence=>20
,p_display_value=>'DROPDOWN_MENU'
,p_return_value=>'DROPDOWN_MENU'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(71172822600142986449)
,p_plugin_attribute_id=>wwv_flow_api.id(71172820216634981739)
,p_display_sequence=>30
,p_display_value=>'HORIZONTAL_BAR'
,p_return_value=>'HORIZONTAL_BAR'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172823310877989592)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'address'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Type the name of a page item containing the address to show.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45920791166820201451)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Pin icon'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Specify an icon to overwrite GMAP''s pin'
,p_attribute_comment=>'Extensión por JCOVES 20110725'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(45920881860662561873)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Latitude and Longitude '
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_default_value=>'0.0, 0.0'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(71172823310877989592)
,p_depending_on_condition_type=>'NULL'
,p_help_text=>'Enter latitude and longitude separated by comma instead of address if you need to increase performance. Example: 41.380268, 2.190475'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(71172841098112014231)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'zoom'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'between 0 and 21'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(53618012282633154895)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Group'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>3
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0D0A202A206A517565727920676F4D61700D0A202A0D0A202A204075726C0909687474703A2F2F7777772E7069747473732E6C762F6A71756572792F676F6D61702F0D0A202A2040617574686F72094A657667656E696A73205368747261757373';
wwv_flow_api.g_varchar2_table(2) := '203C70697474737340676D61696C2E636F6D3E0D0A202A204076657273696F6E09312E332E3320323031342E31312E32370D0A202A205468697320736F6674776172652069732072656C656173656420756E64657220746865204D4954204C6963656E73';
wwv_flow_api.g_varchar2_table(3) := '65203C687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F6D69742D6C6963656E73652E7068703E0D0A202A2F0D0A0D0A6576616C2866756E6374696F6E28702C612C632C6B2C652C72297B653D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(4) := '2863297B72657475726E28633C613F27273A65287061727365496E7428632F612929292B2828633D632561293E33353F537472696E672E66726F6D43686172436F646528632B3239293A632E746F537472696E6728333629297D3B6966282127272E7265';
wwv_flow_api.g_varchar2_table(5) := '706C616365282F5E2F2C537472696E6729297B7768696C6528632D2D29725B652863295D3D6B5B635D7C7C652863293B6B3D5B66756E6374696F6E2865297B72657475726E20725B655D7D5D3B653D66756E6374696F6E28297B72657475726E275C5C77';
wwv_flow_api.g_varchar2_table(6) := '2B277D3B633D317D3B7768696C6528632D2D296966286B5B635D29703D702E7265706C616365286E65772052656745787028275C5C62272B652863292B275C5C62272C276727292C6B5B635D293B72657475726E20707D282728632824297B6220324B3D';
wwv_flow_api.g_varchar2_table(7) := '7920682E672E337728293B6320316F2874297B332E31362874297D3B316F2E31573D7920682E672E337828293B316F2E31572E34683D6328297B7D3B316F2E31572E34323D6328297B7D3B316F2E31572E33763D6328297B7D3B242E6B3D7B7D3B242E33';
wwv_flow_api.g_varchar2_table(8) := '732E6B3D632835297B7220332E3466286328297B62206B3D242833292E6F285C276B5C27293B3728216B297B622031793D242E314828422C7B7D2C242E3179293B242833292E6F285C276B5C272C31792E324828332C3529293B242E6B3D31797D6E7B24';
wwv_flow_api.g_varchar2_table(9) := '2E6B3D6B7D7D297D3B242E31793D7B324F3A7B443A5C275C272C473A33562E392C463A32342E312C32423A342C314C3A34372C32583A422C33383A422C33393A5C27336F5C272C336D3A5C2733755C272C32463A5C2733465C272C31773A422C583A7B75';
wwv_flow_api.g_varchar2_table(10) := '3A5C2734395C272C4A3A5C2733315C277D2C326A3A422C5A3A7B753A5C2733715C272C4A3A5C2733315C277D2C32653A772C32643A422C33793A772C33453A482C32633A772C32413A772C653A5B5D2C433A5B5D2C31693A7B4F3A5C2723316A5C272C4D';
wwv_flow_api.g_varchar2_table(11) := '3A312E302C4E3A327D2C31393A7B4F3A5C2723316A5C272C4D3A312E302C4E3A322C523A5C2723316A5C272C533A302E327D2C553A7B4F3A5C2723316A5C272C4D3A312E302C4E3A322C523A5C2723316A5C272C533A302E327D2C31513A7B4F3A5C2723';
wwv_flow_api.g_varchar2_table(12) := '316A5C272C4D3A312E302C4E3A322C523A5C2723316A5C272C533A302E327D2C336B3A5C27334A5C272C31703A5C273C316C2033573D223359223E5C272C31763A5C273C2F316C3E5C272C31743A777D2C743A482C314B3A302C653A5B5D2C32503A5B5D';
wwv_flow_api.g_varchar2_table(13) := '2C32513A5B5D2C32523A5B5D2C32533A5B5D2C31413A5B5D2C31453A5B5D2C31673A772C31623A482C433A482C783A482C703A482C32673A482C32393A482C326F3A482C327A3A482C383A482C314F3A482C32483A632832682C35297B6220383D242E31';
wwv_flow_api.g_varchar2_table(14) := '4828422C7B7D2C242E31792E324F2C35293B332E703D24283268293B332E383D383B3728382E4429332E3134287B443A382E442C31643A427D293B6E203728242E325428382E65292626382E652E763E30297B3728382E655B305D2E4429332E3134287B';
wwv_flow_api.g_varchar2_table(15) := '443A382E655B305D2E442C31643A427D293B6E20332E314F3D7920682E672E5728382E655B305D2E472C382E655B305D2E46297D6E20332E314F3D7920682E672E5728382E472C382E46293B622033333D7B31643A332E314F2C32633A382E32632C326A';
wwv_flow_api.g_varchar2_table(16) := '3A382E326A2C32413A382E32412C5A3A7B753A682E672E31735B382E5A2E752E313128295D2C4A3A682E672E33625B382E5A2E4A2E313128295D7D2C33663A682E672E33725B382E336B2E313128295D2C33673A382E31772C33693A382E31772C336A3A';
wwv_flow_api.g_varchar2_table(17) := '7B753A682E672E31735B382E582E752E313128295D7D2C31493A7B753A682E672E31735B382E582E752E313128295D2C4A3A682E672E32385B382E582E4A2E313128295D7D2C32653A382E32652C32643A382E32642C32423A382E32427D3B332E743D79';
wwv_flow_api.g_varchar2_table(18) := '20682E672E33422832682C3333293B332E783D7920316F28332E74293B332E433D7B31693A7B713A5C2732675C272C7A3A5C2732505C272C314D3A5C2732495C277D2C31393A7B713A5C2732395C272C7A3A5C2732515C272C314D3A5C27324A5C277D2C';
wwv_flow_api.g_varchar2_table(19) := '553A7B713A5C27326F5C272C7A3A5C2732525C272C314D3A5C27324C5C277D2C31513A7B713A5C27327A5C272C7A3A5C2732535C272C314D3A5C27324E5C277D7D3B332E32673D24285C273C316C204A3D22513A31593B222F3E5C27292E323128332E70';
wwv_flow_api.g_varchar2_table(20) := '293B332E32393D24285C273C316C204A3D22513A31593B222F3E5C27292E323128332E70293B332E326F3D24285C273C316C204A3D22513A31593B222F3E5C27292E323128332E70293B332E327A3D24285C273C316C204A3D22513A31593B222F3E5C27';
wwv_flow_api.g_varchar2_table(21) := '292E323128332E70293B492862206A3D302C6C3D382E652E763B6A3C6C3B6A2B2B29332E314A28382E655B6A5D293B492862206A3D302C6C3D382E432E763B6A3C6C3B6A2B2B29335B332E435B382E435B6A5D2E645D2E314D5D28382E435B6A5D293B62';
wwv_flow_api.g_varchar2_table(22) := '206B3D333B3728382E31743D3D427C7C382E31743D3D5C2733705C27297B682E672E4C2E316E286B2E742C5C2732625C272C63284C297B6220353D7B753A4C2E33612C317A3A427D3B6220363D6B2E314A2835293B682E672E4C2E316E28362C5C273247';
wwv_flow_api.g_varchar2_table(23) := '5C272C63284C297B362E31362848293B6B2E327228362E71297D297D297D6E203728382E31743D3D5C2733445C27297B682E672E4C2E316E286B2E742C5C2732625C272C63284C297B3728216B2E3150297B6220353D7B753A4C2E33612C317A3A427D3B';
wwv_flow_api.g_varchar2_table(24) := '6220363D6B2E314A2835293B6B2E31503D423B682E672E4C2E316E28362C5C2732475C272C63284C297B362E31362848293B6B2E327228362E71293B6B2E31503D777D297D7D297D4B20382E653B4B20382E433B7220337D2C33473A632866297B682E67';
wwv_flow_api.g_varchar2_table(25) := '2E4C2E334E28332E742C5C2733525C272C6328297B72206628297D297D2C31343A6328442C35297B62206B3D333B3156286328297B324B2E3134287B5C27445C273A442E447D2C632831582C3146297B372831463D3D682E672E315A2E326B2626442E31';
wwv_flow_api.g_varchar2_table(26) := '64296B2E742E34342831585B305D2E326C2E326E293B372831463D3D682E672E315A2E326B2626352626352E4529352E452E34612831585B305D2E326C2E326E293B6E20372831463D3D682E672E315A2E326B262635297B37286B2E3167297B6B2E3167';
wwv_flow_api.g_varchar2_table(27) := '3D773B352E753D31585B305D2E326C2E326E3B352E31343D423B6B2E314A2835297D7D6E20372831463D3D682E672E315A2E3463297B6B2E313428442C35297D7D297D2C332E382E314C297D2C32713A6328297B3728332E31452E763E30262621332E31';
wwv_flow_api.g_varchar2_table(28) := '67297B332E31673D423B622031383D332E31452E323628302C31293B332E3134287B443A31385B305D2E447D2C31385B305D297D6E203728332E3167297B62206B3D333B3156286328297B6B2E327128297D2C332E382E314C297D7D2C31363A63283529';
wwv_flow_api.g_varchar2_table(29) := '7B4B20352E33663B3728352E44297B332E3134287B443A352E442C31643A427D293B4B20352E447D6E203728352E472626352E46297B352E31643D7920682E672E5728352E472C352E46293B4B20352E463B4B20352E477D3728352E5A2626352E5A2E75';
wwv_flow_api.g_varchar2_table(30) := '29352E5A2E753D682E672E31735B352E5A2E752E313128295D3B3728352E5A2626352E5A2E4A29352E5A2E4A3D682E672E33625B352E5A2E4A2E313128295D3B3728316820352E3177213D3D5C2731475C27297B352E33673D352E31773B352E33693D35';
wwv_flow_api.g_varchar2_table(31) := '2E31777D3728352E582626352E582E75297B352E336A3D7B753A682E672E31735B352E582E752E313128295D7D3B352E31493D7B753A682E672E31735B352E582E752E313128295D7D7D3728352E582626352E582E4A297B3728316820352E31493D3D3D';
wwv_flow_api.g_varchar2_table(32) := '5C2731475C2729352E31493D7B4A3A682E672E32385B352E582E4A2E313128295D7D3B6E20352E31492E4A3D682E672E32385B352E582E4A2E313128295D7D332E742E31552835297D2C32553A6328297B7220332E747D2C32573A6328642C4C2C6F297B';
wwv_flow_api.g_varchar2_table(33) := '6220316B3B372831682064213D5C2732595C2729643D7B643A647D3B3728642E643D3D5C27745C2729316B3D332E743B6E203728642E643D3D5C27365C272626642E3629316B3D2428332E70292E6F28642E36293B6E203728642E643D3D5C276D5C2726';
wwv_flow_api.g_varchar2_table(34) := '26642E3629316B3D2428332E70292E6F28642E362B5C276D5C27293B3728316B297220682E672E4C2E316E28316B2C4C2C6F293B6E20372828642E643D3D5C27365C277C7C642E643D3D5C276D5C27292626332E32452829213D332E326928292962206B';
wwv_flow_api.g_varchar2_table(35) := '3D333B3156286328297B6B2E325728642C4C2C6F297D2C332E382E314C297D2C33343A63283335297B682E672E4C2E3334283335297D2C33363A6328362C41297B62206B3D333B412E31783D6B2E382E31702B412E31782B6B2E382E31763B6220503D79';
wwv_flow_api.g_varchar2_table(36) := '20682E672E334D2841293B502E593D773B24286B2E70292E6F28362E712B5C276D5C272C50293B3728412E334F297B6B2E327028502C362C41293B502E593D427D682E672E4C2E316E28362C5C2732625C272C6328297B3728502E5926266B2E382E3258';
wwv_flow_api.g_varchar2_table(37) := '297B502E317528293B502E593D777D6E7B6B2E327028502C362C41293B502E593D427D7D297D2C32703A6328502C362C41297B62206B3D333B3728332E382E333829332E336828293B3728412E3235297B502E327428332E742C36293B242E3235287B34';
wwv_flow_api.g_varchar2_table(38) := '303A412E32352C34313A632841297B502E3275286B2E382E31702B412B6B2E382E3176297D7D297D6E203728412E71297B502E3275286B2E382E31702B2428412E71292E4128292B6B2E382E3176293B502E327428332E742C36297D6E20502E32742833';
wwv_flow_api.g_varchar2_table(39) := '2E742C36297D2C34333A6328712C314E297B62206D3D2428332E70292E6F28712B5C276D5C27293B3728316820314E3D3D5C2732595C27296D2E3155286B2E382E31702B314E2B6B2E382E3176293B6E206D2E3275286B2E382E31702B314E2B6B2E382E';
wwv_flow_api.g_varchar2_table(40) := '3176297D2C34353A6328712C336C297B62206D3D2428332E70292E6F28712B5C276D5C27292E343828293B3728336C29722024286D292E4128293B6E2072206D7D2C33683A6328297B49286220693D302C6C3D332E652E763B693C6C3B692B2B297B6220';
wwv_flow_api.g_varchar2_table(41) := '6D3D2428332E70292E6F28332E655B695D2B5C276D5C27293B37286D297B6D2E317528293B6D2E593D777D7D7D2C32433A6328642C65297B62206B3D333B3728332E32452829213D332E32692829293156286328297B6B2E324328642C65297D2C332E38';
wwv_flow_api.g_varchar2_table(42) := '2E314C293B6E7B332E31623D7920682E672E323728293B372821647C7C28642626643D3D5C2734625C2729297B49286220693D302C6C3D332E652E763B693C6C3B692B2B297B332E31622E3148282428332E70292E6F28332E655B695D292E75297D7D6E';
wwv_flow_api.g_varchar2_table(43) := '203728642626643D3D5C2731425C27297B49286220693D302C6C3D332E652E763B693C6C3B692B2B297B3728332E314328332E655B695D2929332E31622E3148282428332E70292E6F28332E655B695D292E75297D7D6E203728642626643D3D5C27655C';
wwv_flow_api.g_varchar2_table(44) := '272626242E3254286529297B49286220693D302C6C3D652E763B693C6C3B692B2B297B332E31622E3148282428332E70292E6F28655B695D292E75297D7D332E742E324328332E3162297D7D2C32613A6328297B7220332E742E326128297D2C32493A63';
wwv_flow_api.g_varchar2_table(45) := '2861297B612E643D5C2731695C273B7220332E31442861297D2C324A3A632861297B612E643D5C2731395C273B7220332E31442861297D2C324C3A632861297B612E643D5C27555C273B7220332E31442861297D2C324E3A632861297B612E643D5C2731';
wwv_flow_api.g_varchar2_table(46) := '515C273B7220332E31442861297D2C31443A632861297B6220783D5B5D3B372821612E71297B332E314B2B2B3B612E713D332E382E336D2B332E314B7D324D28612E64297B31375C2731695C273A3728612E562E763E30297B492862206A3D302C6C3D61';
wwv_flow_api.g_varchar2_table(47) := '2E562E763B6A3C6C3B6A2B2B29782E54287920682E672E5728612E565B6A5D2E472C612E565B6A5D2E4629293B783D7920682E672E3374287B743A332E742C32663A782C31523A612E4F3F612E4F3A332E382E31692E4F2C31533A612E4D3F612E4D3A33';
wwv_flow_api.g_varchar2_table(48) := '2E382E31692E4D2C31543A612E4E3F612E4E3A332E382E31692E4E7D297D6E207220773B31303B31375C2731395C273A3728612E562E763E30297B492862206A3D302C6C3D612E562E763B6A3C6C3B6A2B2B29782E54287920682E672E5728612E565B6A';
wwv_flow_api.g_varchar2_table(49) := '5D2E472C612E565B6A5D2E4629293B783D7920682E672E337A287B743A332E742C32663A782C31523A612E4F3F612E4F3A332E382E31392E4F2C31533A612E4D3F612E4D3A332E382E31392E4D2C31543A612E4E3F612E4E3A332E382E31392E4E2C523A';
wwv_flow_api.g_varchar2_table(50) := '612E523F612E523A332E382E31392E522C533A612E533F612E533A332E382E31392E537D297D6E207220773B31303B31375C27555C273A783D7920682E672E3341287B743A332E742C31643A7920682E672E5728612E472C612E46292C32563A612E3256';
wwv_flow_api.g_varchar2_table(51) := '2C31523A612E4F3F612E4F3A332E382E552E4F2C31533A612E4D3F612E4D3A332E382E552E4D2C31543A612E4E3F612E4E3A332E382E552E4E2C523A612E523F612E523A332E382E552E522C533A612E533F612E533A332E382E552E537D293B31303B31';
wwv_flow_api.g_varchar2_table(52) := '375C2731515C273A783D7920682E672E3343287B743A332E742C31623A7920682E672E3237287920682E672E5728612E31722E472C612E31722E46292C7920682E672E5728612E31712E472C612E31712E4629292C31523A612E4F3F612E4F3A332E382E';
wwv_flow_api.g_varchar2_table(53) := '552E4F2C31533A612E4D3F612E4D3A332E382E552E4D2C31543A612E4E3F612E4E3A332E382E552E4E2C523A612E523F612E523A332E382E552E522C533A612E533F612E533A332E382E552E537D293B31303B326D3A7220773B31307D332E325A28612C';
wwv_flow_api.g_varchar2_table(54) := '78293B7220787D2C325A3A6328612C78297B2428335B332E435B612E645D2E715D292E6F28612E712C78293B335B332E435B612E645D2E7A5D2E5428612E71297D2C33483A6328642C782C35297B783D2428335B332E435B645D2E715D292E6F2878293B';
wwv_flow_api.g_varchar2_table(55) := '3728352E562626352E562E763E30297B62207A3D5B5D3B492862206A3D302C6C3D352E562E763B6A3C6C3B6A2B2B297A2E54287920682E672E5728352E565B6A5D2E472C352E565B6A5D2E4629293B352E32663D7A3B4B20352E567D6E203728352E3171';
wwv_flow_api.g_varchar2_table(56) := '2626352E3172297B352E31623D7920682E672E3237287920682E672E5728352E31722E472C352E31722E46292C7920682E672E5728352E31712E472C352E31712E4629293B4B20352E31713B4B20352E31727D6E203728352E472626352E46297B352E31';
wwv_flow_api.g_varchar2_table(57) := '643D7920682E672E5728352E472C352E46293B4B20352E473B4B20352E467D782E31552835297D2C33493A6328642C782C51297B3728316820513D3D3D5C2731475C27297B3728332E333028642C782929513D773B6E20513D427D372851292428335B33';
wwv_flow_api.g_varchar2_table(58) := '2E435B645D2E715D292E6F2878292E313628332E74293B6E202428335B332E435B645D2E715D292E6F2878292E31362848297D2C33303A6328642C78297B37282428335B332E435B645D2E715D292E6F2878292E32552829297220423B6E207220777D2C';
wwv_flow_api.g_varchar2_table(59) := '334B3A632864297B7220335B332E435B645D2E7A5D2E767D2C334C3A6328642C78297B622031663D242E333228782C335B332E435B645D2E7A5D292C31383B372831663E2D31297B31383D335B332E435B645D2E7A5D2E32362831662C31293B6220453D';
wwv_flow_api.g_varchar2_table(60) := '31385B305D3B2428335B332E435B645D2E715D292E6F2845292E31362848293B2428335B332E435B645D2E715D292E316D2845293B7220427D7220777D2C33503A632864297B49286220693D302C6C3D335B332E435B645D2E7A5D2E763B693C6C3B692B';
wwv_flow_api.g_varchar2_table(61) := '2B297B6220453D335B332E435B645D2E7A5D5B695D3B2428335B332E435B645D2E715D292E6F2845292E31362848293B2428335B332E435B645D2E715D292E316D2845297D335B332E435B645D2E7A5D3D5B5D7D2C33513A6328362C51297B3728316820';
wwv_flow_api.g_varchar2_table(62) := '513D3D3D5C2731475C27297B3728332E3143283629297B2428332E70292E6F2836292E31632877293B62206D3D2428332E70292E6F28362B5C276D5C27293B37286D26266D2E59297B6D2E317528293B6D2E593D777D7D6E202428332E70292E6F283629';
wwv_flow_api.g_varchar2_table(63) := '2E31632842297D6E202428332E70292E6F2836292E31632851297D2C33533A632831332C51297B49286220693D302C6C3D332E652E763B693C6C3B692B2B297B6220453D332E655B695D3B6220363D2428332E70292E6F2845293B3728362E31333D3D31';
wwv_flow_api.g_varchar2_table(64) := '33297B3728316820513D3D3D5C2731475C27297B3728332E3143284529297B362E31632877293B62206D3D2428332E70292E6F28452B5C276D5C27293B37286D26266D2E59297B6D2E317528293B6D2E593D777D7D6E20362E31632842297D6E20362E31';
wwv_flow_api.g_varchar2_table(65) := '632851297D7D7D2C31433A632836297B72202428332E70292E6F2836292E335428297D2C32453A6328297B7220332E652E767D2C32693A6328297B7220332E31412E767D2C33553A6328297B7220332E3230285C2733375C27292E767D2C33583A632831';
wwv_flow_api.g_varchar2_table(66) := '33297B7220332E3230285C2731335C272C3133292E767D2C32303A6328642C3273297B62207A3D5B5D3B324D2864297B313722335A223A49286220693D302C6C3D332E652E763B693C6C3B692B2B297B622031613D225C27222B692B225C273A205C2722';
wwv_flow_api.g_varchar2_table(67) := '2B2428332E70292E6F28332E655B695D292E323228292E327628292B225C27223B7A2E54283161297D7A3D227B5C27655C273A7B222B7A2E336328222C22292B227D7D223B31303B3137226F223A49286220693D302C6C3D332E652E763B693C6C3B692B';
wwv_flow_api.g_varchar2_table(68) := '2B297B622031613D22365B222B692B225D3D222B2428332E70292E6F28332E655B695D292E323228292E327628293B7A2E54283161297D7A3D7A2E336328222622293B31303B3137223364223A49286220693D302C6C3D332E652E763B693C6C3B692B2B';
wwv_flow_api.g_varchar2_table(69) := '297B3728332E3365282428332E70292E6F28332E655B695D292E3232282929297A2E5428332E655B695D297D31303B3137223337223A49286220693D302C6C3D332E652E763B693C6C3B692B2B297B3728332E314328332E655B695D29297A2E5428332E';
wwv_flow_api.g_varchar2_table(70) := '655B695D297D31303B3137223133223A372832732949286220693D302C6C3D332E652E763B693C6C3B692B2B297B37282428332E70292E6F28332E655B695D292E31333D3D3273297A2E5428332E655B695D297D31303B31372265223A49286220693D30';
wwv_flow_api.g_varchar2_table(71) := '2C6C3D332E652E763B693C6C3B692B2B297B622031613D2428332E70292E6F28332E655B695D293B7A2E54283161297D31303B326D3A49286220693D302C6C3D332E652E763B693C6C3B692B2B297B622031613D2428332E70292E6F28332E655B695D29';
wwv_flow_api.g_varchar2_table(72) := '2E323228292E327628293B7A2E54283161297D31307D72207A7D2C34363A6328297B7220332E3230285C2733645C27297D2C314A3A632836297B372821362E3134297B332E314B2B2B3B372821362E7129362E713D332E382E33392B332E314B3B332E31';
wwv_flow_api.g_varchar2_table(73) := '412E5428362E71297D3728362E44262621362E3134297B332E31452E542836293B332E327128297D6E203728362E472626362E467C7C362E75297B6220353D7B743A332E747D3B352E713D362E713B352E31333D362E31333F362E31333A332E382E3246';
wwv_flow_api.g_varchar2_table(74) := '3B352E32773D362E32773F362E32773A303B352E32783D362E32783F362E32783A303B3728362E31423D3D7729352E31423D362E31423B3728362E327929352E32793D362E32793B3728362E317A29352E317A3D362E317A3B3728362E732626362E732E';
wwv_flow_api.g_varchar2_table(75) := '3165297B352E733D362E732E31653B3728362E732E313229352E31323D362E732E31327D6E203728362E7329352E733D362E733B6E203728332E382E732626332E382E732E3165297B352E733D332E382E732E31653B3728332E382E732E313229352E31';
wwv_flow_api.g_varchar2_table(76) := '323D332E382E732E31327D6E203728332E382E7329352E733D332E382E733B352E753D362E753F362E753A7920682E672E5728362E472C362E46293B622032333D7920682E672E34642835293B3728362E41297B372821362E412E3178262621362E412E';
wwv_flow_api.g_varchar2_table(77) := '3235262621362E412E7129362E413D7B31783A362E417D3B6E20372821362E412E317829362E412E31783D483B332E33362832332C362E41297D332E3174283233293B722032337D7D2C31743A632836297B2428332E70292E6F28362E712C36293B332E';
wwv_flow_api.g_varchar2_table(78) := '652E5428362E71297D2C34653A6328362C35297B622032443D2428332E70292E6F2836293B4B20352E713B4B20352E31423B3728352E73297B622031353D352E733B4B20352E733B37283135262631353D3D5C27326D5C27297B3728332E382E73262633';
wwv_flow_api.g_varchar2_table(79) := '2E382E732E3165297B352E733D332E382E732E31653B3728332E382E732E313229352E31323D332E382E732E31327D6E203728332E382E7329352E733D332E382E737D6E2037283135262631352E3165297B352E733D31352E31653B372831352E313229';
wwv_flow_api.g_varchar2_table(80) := '352E31323D31352E31327D6E203728313529352E733D31357D3728352E44297B332E3134287B443A352E447D2C7B453A32447D293B4B20352E443B4B20352E473B4B20352E463B4B20352E757D6E203728352E472626352E467C7C352E75297B37282135';
wwv_flow_api.g_varchar2_table(81) := '2E7529352E753D7920682E672E5728352E472C352E46297D32442E31552835297D2C32723A632836297B622031663D242E333228362C332E65292C31383B372831663E2D31297B332E31412E32362831662C31293B31383D332E652E32362831662C3129';
wwv_flow_api.g_varchar2_table(82) := '3B6220453D31385B305D3B6220363D2428332E70292E6F2845293B62206D3D2428332E70292E6F28452B5C276D5C27293B362E31632877293B362E31362848293B2428332E70292E316D2845293B37286D297B6D2E317528293B6D2E593D773B2428332E';
wwv_flow_api.g_varchar2_table(83) := '70292E316D28452B5C276D5C27297D7220427D7220777D2C34673A6328297B49286220693D302C6C3D332E652E763B693C6C3B692B2B297B6220453D332E655B695D3B6220363D2428332E70292E6F2845293B62206D3D2428332E70292E6F28452B5C27';
wwv_flow_api.g_varchar2_table(84) := '6D5C27293B362E31632877293B362E31362848293B2428332E70292E316D2845293B37286D297B6D2E317528293B6D2E593D773B2428332E70292E316D28452B5C276D5C27297D7D332E31503D773B332E31673D773B332E653D5B5D3B332E31413D5B5D';
wwv_flow_api.g_varchar2_table(85) := '3B332E31453D5B5D7D2C33653A6328336E297B7220332E742E326128292E346928336E297D7D7D2928346A293B272C36322C3236382C277C7C7C746869737C7C6F7074696F6E737C6D61726B65727C69667C6F7074737C7C706F6C797C7661727C66756E';
wwv_flow_api.g_varchar2_table(86) := '6374696F6E7C747970657C6D61726B6572737C7C6D6170737C676F6F676C657C7C7C676F4D61707C7C696E666F7C656C73657C646174617C6D617049647C69647C72657475726E7C69636F6E7C6D61707C706F736974696F6E7C6C656E6774687C66616C';
wwv_flow_api.g_varchar2_table(87) := '73657C6F7665726C61797C6E65777C61727261797C68746D6C7C747275657C6F7665726C6179737C616464726573737C6D61726B657249647C6C6F6E6769747564657C6C617469747564657C6E756C6C7C666F727C7374796C657C64656C6574657C6576';
wwv_flow_api.g_varchar2_table(88) := '656E747C6F7061636974797C7765696768747C636F6C6F727C696E666F77696E646F777C646973706C61797C66696C6C436F6C6F727C66696C6C4F7061636974797C707573687C636972636C657C636F6F7264737C4C61744C6E677C6E61766967617469';
wwv_flow_api.g_varchar2_table(89) := '6F6E436F6E74726F6C4F7074696F6E737C73686F777C6D617054797065436F6E74726F6C4F7074696F6E737C627265616B7C746F5570706572436173657C736861646F777C67726F75707C67656F636F64657C746F7074696F6E7C7365744D61707C6361';
wwv_flow_api.g_varchar2_table(90) := '73657C63757272656E747C706F6C79676F6E7C74656D707C626F756E64737C73657456697369626C657C63656E7465727C696D6167657C696E6465787C6C6F636B47656F636F64657C747970656F667C706F6C796C696E657C4646303030307C74617267';
wwv_flow_api.g_varchar2_table(91) := '65747C6469767C72656D6F7665446174617C6164644C697374656E65727C4D794F7665726C61797C68746D6C5F70726570656E647C6E657C73777C436F6E74726F6C506F736974696F6E7C6164644D61726B65727C636C6F73657C68746D6C5F61707065';
wwv_flow_api.g_varchar2_table(92) := '6E647C6E617669676174696F6E436F6E74726F6C7C636F6E74656E747C676F4D6170426173657C647261676761626C657C746D704D61726B6572737C76697369626C657C67657456697369626C654D61726B65727C6372656174654F7665726C61797C67';
wwv_flow_api.g_varchar2_table(93) := '656F4D61726B6572737C7374617475737C756E646566696E65647C657874656E647C7A6F6F6D436F6E74726F6C4F7074696F6E737C6372656174654D61726B65727C636F756E747C64656C61797C6372656174657C746578747C63656E7465724C61744C';
wwv_flow_api.g_varchar2_table(94) := '6E677C73696E676C654D61726B65727C72656374616E676C657C7374726F6B65436F6C6F727C7374726F6B654F7061636974797C7374726F6B655765696768747C7365744F7074696F6E737C73657454696D656F75747C70726F746F747970657C726573';
wwv_flow_api.g_varchar2_table(95) := '756C74737C6E6F6E657C47656F636F6465725374617475737C6765744D61726B6572737C617070656E64546F7C676574506F736974696F6E7C636D61726B65727C7C616A61787C73706C6963657C4C61744C6E67426F756E64737C5A6F6F6D436F6E7472';
wwv_flow_api.g_varchar2_table(96) := '6F6C5374796C657C706749647C676574426F756E64737C636C69636B7C64697361626C65446F75626C65436C69636B5A6F6F6D7C7363726F6C6C776865656C7C7363616C65436F6E74726F6C7C706174687C706C49647C656C7C676574546D704D61726B';
wwv_flow_api.g_varchar2_table(97) := '6572436F756E747C6D617054797065436F6E74726F6C7C4F4B7C67656F6D657472797C64656661756C747C6C6F636174696F6E7C6349647C6F70656E57696E646F777C67656F4D61726B65727C72656D6F76654D61726B65727C6E616D657C6F70656E7C';
wwv_flow_api.g_varchar2_table(98) := '736574436F6E74656E747C746F55726C56616C75657C7A496E6465787C7A496E6465784F72677C7469746C657C7249647C73747265657456696577436F6E74726F6C7C7A6F6F6D7C666974426F756E64737C746D61726B65727C6765744D61726B657243';
wwv_flow_api.g_varchar2_table(99) := '6F756E747C67726F757049647C64626C636C69636B7C696E69747C637265617465506F6C796C696E657C637265617465506F6C79676F6E7C67656F636F6465727C637265617465436972636C657C7377697463687C63726561746552656374616E676C65';
wwv_flow_api.g_varchar2_table(100) := '7C64656661756C74737C706F6C796C696E65737C706F6C79676F6E737C636972636C65737C72656374616E676C65737C697341727261797C6765744D61707C7261646975737C6372656174654C697374656E65727C686964654279436C69636B7C6F626A';
wwv_flow_api.g_varchar2_table(101) := '6563747C6164644F7665726C61797C67657456697369626C654F7665726C61797C44454641554C547C696E41727261797C6D794F7074696F6E737C72656D6F76654C697374656E65727C6C697374656E65727C736574496E666F57696E646F777C766973';
wwv_flow_api.g_varchar2_table(102) := '69626C6573496E4D61707C6F6E65496E666F57696E646F777C70726566697849647C6C61744C6E677C4D617054797065436F6E74726F6C5374796C657C6A6F696E7C76697369626C6573496E426F756E64737C697356697369626C657C6D617054797065';
wwv_flow_api.g_varchar2_table(103) := '49647C70616E436F6E74726F6C7C636C656172496E666F7C7A6F6F6D436F6E74726F6C7C70616E436F6E74726F6C4F7074696F6E737C6D6170747970657C686964654469767C706F6C7949647C6C61746C6E677C676F6D61726B65727C6D756C74697C54';
wwv_flow_api.g_varchar2_table(104) := '4F505F52494748547C4D61705479706549647C666E7C506F6C796C696E657C676F706F6C797C647261777C47656F636F6465727C4F7665726C6179566965777C646972656374696F6E737C506F6C79676F6E7C436972636C657C4D61707C52656374616E';
wwv_flow_api.g_varchar2_table(105) := '676C657C73696E676C657C646972656374696F6E73526573756C747C676F67726F75707C72656164797C7365744F7665726C61797C73686F77486964654F7665726C61797C4859425249447C6765744F7665726C617973436F756E747C72656D6F76654F';
wwv_flow_api.g_varchar2_table(106) := '7665726C61797C496E666F57696E646F777C6164644C697374656E65724F6E63657C706F7075707C636C6561724F7665726C6179737C73686F77486964654D61726B65727C626F756E64735F6368616E6765647C73686F77486964654D61726B65724279';
wwv_flow_api.g_varchar2_table(107) := '47726F75707C67657456697369626C657C67657456697369626C654D61726B6572436F756E747C35367C636C6173737C6765744D61726B6572427947726F7570436F756E747C676F6D61704D61726B65727C6A736F6E7C75726C7C737563636573737C6F';
wwv_flow_api.g_varchar2_table(108) := '6E52656D6F76657C736574496E666F7C73657443656E7465727C676574496E666F7C67657456697369626C654D61726B6572737C3230307C676574436F6E74656E747C544F505F4C4546547C736574506F736974696F6E7C616C6C7C4F5645525F515545';
wwv_flow_api.g_varchar2_table(109) := '52595F4C494D49547C4D61726B65727C7365744D61726B65727C656163687C636C6561724D61726B6572737C6F6E4164647C636F6E7461696E737C6A5175657279272E73706C697428277C27292C302C7B7D2929';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(53480290940043189667)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_file_name=>'jquery.gomap-1.3.3.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0D0A202A206A517565727920676F4D61700D0A202A0D0A202A204075726C0909687474703A2F2F7777772E7069747473732E6C762F6A71756572792F676F6D61702F0D0A202A2040617574686F72094A657667656E696A73205368747261757373';
wwv_flow_api.g_varchar2_table(2) := '203C70697474737340676D61696C2E636F6D3E0D0A202A204076657273696F6E09312E322E320D0A202A205468697320736F6674776172652069732072656C656173656420756E64657220746865204D4954204C6963656E7365203C687474703A2F2F77';
wwv_flow_api.g_varchar2_table(3) := '77772E6F70656E736F757263652E6F72672F6C6963656E7365732F6D69742D6C6963656E73652E7068703E0D0A202A2F0D0A0D0A6576616C2866756E6374696F6E28702C612C632C6B2C652C72297B653D66756E6374696F6E2863297B72657475726E28';
wwv_flow_api.g_varchar2_table(4) := '633C613F27273A65287061727365496E7428632F612929292B2828633D632561293E33353F537472696E672E66726F6D43686172436F646528632B3239293A632E746F537472696E6728333629297D3B6966282127272E7265706C616365282F5E2F2C53';
wwv_flow_api.g_varchar2_table(5) := '7472696E6729297B7768696C6528632D2D29725B652863295D3D6B5B635D7C7C652863293B6B3D5B66756E6374696F6E2865297B72657475726E20725B655D7D5D3B653D66756E6374696F6E28297B72657475726E275C5C772B277D3B633D317D3B7768';
wwv_flow_api.g_varchar2_table(6) := '696C6528632D2D296966286B5B635D29703D702E7265706C616365286E65772052656745787028275C5C62272B652863292B275C5C62272C276727292C6B5B635D293B72657475726E20707D282728622824297B632032703D7820672E662E324128293B';
wwv_flow_api.g_varchar2_table(7) := '62205A2871297B372E31322871297D3B5A2E316D3D7820672E662E324828293B5A2E316D2E324B3D6228297B7D3B5A2E316D2E32533D6228297B7D3B5A2E316D2E32553D6228297B7D3B242E32762E333D622832297B6320383D242E3169287B7D2C242E';
wwv_flow_api.g_varchar2_table(8) := '332E316C2C32293B7220372E3257286228297B242E332E6D3D373B242E332E383D383B242E332E613D5B5D3B242E332E31303D5B5D3B242E332E553D7A3B242E332E326F2838297D297D3B242E333D7B316C3A7B743A5C275C272C413A33312E392C793A';
wwv_flow_api.g_varchar2_table(9) := '32342E312C31513A342C31643A32492C32683A752C32643A752C32633A5C2733305C272C314D3A752C453A7B6F3A5C2732785C272C443A5C2732395C277D2C314C3A752C433A7B6F3A5C2732465C272C443A5C2732395C277D2C314B3A702C314A3A752C';
wwv_flow_api.g_varchar2_table(10) := '324D3A702C32513A7A2C31473A702C31463A702C613A5B5D2C315A3A5C27325A5C272C31593A5C273C31562033383D32723E5C272C31543A5C273C2F31563E5C272C533A707D2C713A7A2C31433A302C613A5B5D2C31303A5B5D2C31313A7A2C32673A7A';
wwv_flow_api.g_varchar2_table(11) := '2C6D3A7A2C383A7A2C553A7A2C326F3A622838297B3628382E7429242E332E5028382E742C75293B68203628382E41213D372E316C2E412626382E79213D372E316C2E7929372E553D7820672E662E5428382E412C382E79293B68203628242E32612838';
wwv_flow_api.g_varchar2_table(12) := '2E61292626382E612E31653E30297B3628382E615B305D2E7429242E332E5028382E615B305D2E742C75293B6820372E553D7820672E662E5428382E615B305D2E412C382E615B305D2E79297D6820372E553D7820672E662E5428382E412C382E79293B';
wwv_flow_api.g_varchar2_table(13) := '632032383D7B32353A372E552C31473A382E31472C314C3A382E314C2C31463A382E31462C433A7B6F3A4E285C27672E662E316B2E5C272B382E432E6F2E4F2829292C443A4E285C27672E662E32332E5C272B382E432E442E4F2829297D2C32323A4E28';
wwv_flow_api.g_varchar2_table(14) := '5C27672E662E33342E5C272B382E315A2E4F2829292C314D3A382E314D2C453A7B6F3A4E285C27672E662E316B2E5C272B382E452E6F2E4F2829292C443A4E285C27672E662E32302E5C272B382E452E442E4F2829297D2C314B3A382E314B2C314A3A38';
wwv_flow_api.g_varchar2_table(15) := '2E314A2C31513A382E31517D3B242E332E713D7820672E662E327128372E6D2C3238293B242E332E32673D78205A28242E332E71293B472863206A3D303B6A3C382E612E31653B6A2B2B29372E313928382E615B6A5D293B3628382E533D3D757C7C382E';
wwv_flow_api.g_varchar2_table(16) := '533D3D5C2732775C27297B672E662E772E5728242E332E712C5C2731785C272C622877297B6320323D7B6F3A772E326B2C31333A757D3B6320353D242E332E31392832293B672E662E772E5728352C5C2732655C272C622877297B352E3132287A293B24';
wwv_flow_api.g_varchar2_table(17) := '2E332E317428352E73297D297D297D68203628382E533D3D5C27324C5C27297B672E662E772E5728242E332E712C5C2731785C272C622877297B362821242E332E316A297B6320323D7B6F3A772E326B2C31333A757D3B6320353D242E332E3139283229';
wwv_flow_api.g_varchar2_table(18) := '3B242E332E316A3D753B672E662E772E5728352C5C2732655C272C622877297B352E3132287A293B242E332E317428352E73293B242E332E316A3D707D297D7D297D7D2C324F3A6228297B7220242E332E717D2C31323A622832297B4820322E32323B36';
wwv_flow_api.g_varchar2_table(19) := '28322E74297B242E332E5028322E742C75293B4820322E747D68203628322E412626322E79297B322E32353D7820672E662E5428322E412C322E79293B4820322E793B4820322E417D3628322E432626322E432E6F29322E432E6F3D4E285C27672E662E';
wwv_flow_api.g_varchar2_table(20) := '316B2E5C272B322E432E6F2E4F2829293B3628322E432626322E432E4429322E432E443D4E285C27672E662E32332E5C272B322E432E442E4F2829293B3628322E452626322E452E6F29322E452E6F3D4E285C27672E662E316B2E5C272B322E452E6F2E';
wwv_flow_api.g_varchar2_table(21) := '4F2829293B3628322E452626322E452E4429322E452E443D4E285C27672E662E32302E5C272B322E452E442E4F2829293B242E332E712E31452832297D2C326D3A62286C2C772C6E297B6320593B36283158206C213D5C2732365C27296C3D7B6C3A6C7D';
wwv_flow_api.g_varchar2_table(22) := '3B36286C2E6C3D3D5C27715C2729593D242E332E713B682036286C2E6C3D3D5C27355C2726266C2E3529593D2428372E6D292E6E286C2E35293B682036286C2E6C3D3D5C27655C2726266C2E3529593D2428372E6D292E6E286C2E352B5C27655C27293B';
wwv_flow_api.g_varchar2_table(23) := '362859297220672E662E772E5728592C772C6E293B68203628286C2E6C3D3D5C27355C277C7C6C2E6C3D3D5C27655C27292626242E332E31702829213D242E332E31712829293172286228297B242E332E326D286C2C772C6E297D2C372E382E3164297D';
wwv_flow_api.g_varchar2_table(24) := '2C31533A62283157297B672E662E772E3153283157297D2C503A6228742C31732C32297B3172286228297B32702E50287B5C27745C273A747D2C622831672C3134297B362831343D3D672E662E31632E31752626317329242E332E712E31732831675B30';
wwv_flow_api.g_varchar2_table(25) := '5D2E31762E3177293B362831343D3D672E662E31632E31752626322626322E4229322E422E324A2831675B305D2E31762E3177293B6820362831343D3D672E662E31632E3175262632297B322E6F3D31675B305D2E31762E31773B6320513D7820672E66';
wwv_flow_api.g_varchar2_table(26) := '2E32312832293B3628322E64297B362821322E642E4A262621322E642E3136262621322E642E7329322E643D7B4A3A322E647D3B6820362821322E642E4A29322E642E4A3D7A3B242E332E317928512C322E64297D242E332E532851293B7220517D6820';
wwv_flow_api.g_varchar2_table(27) := '362831343D3D672E662E31632E3254297B242E332E5028742C702C32297D7D297D2C372E382E3164297D2C31793A6228352C64297B642E4A3D372E382E31592B642E4A2B372E382E31543B6320763D7820672E662E32562864293B762E493D703B242837';
wwv_flow_api.g_varchar2_table(28) := '2E6D292E6E28352E732B5C27655C272C76293B3628642E3258297B242E332E317A28762C352C64293B762E493D757D672E662E772E5728352C5C2731785C272C6228297B3628762E492626242E332E382E3268297B762E313728293B762E493D707D687B';
wwv_flow_api.g_varchar2_table(29) := '242E332E317A28762C352C64293B762E493D757D7D297D2C317A3A6228762C352C64297B3628242E332E382E326429242E332E326928293B3628642E3136297B762E314128372E712C35293B242E3136287B33353A642E31362C33373A622864297B762E';
wwv_flow_api.g_varchar2_table(30) := '31422864297D7D297D68203628642E73297B762E3142282428642E73292E642829293B762E314128372E712C35297D6820762E314128372E712C35297D2C32693A6228297B4728632069204B20242E332E61297B6320653D2428372E6D292E6E28242E33';
wwv_flow_api.g_varchar2_table(31) := '2E615B695D2B5C27655C27293B362865297B652E313728293B652E493D707D7D7D2C32733A6228732C3155297B6320653D2428372E6D292E6E28732B5C27655C27292E327428293B36283155297220242865292E6428293B68207220657D2C32753A6228';
wwv_flow_api.g_varchar2_table(32) := '732C3162297B6320653D2428372E6D292E6E28732B5C27655C27293B362831582031623D3D5C2732365C27297B652E3145283162297D6820652E3142283162297D2C31443A6228297B7220242E332E712E314428297D2C316F3A62286C2C61297B362824';
wwv_flow_api.g_varchar2_table(33) := '2E332E31702829213D242E332E31712829293172286228297B242E332E316F286C2C61297D2C372E382E3164293B687B242E332E31313D7820672E662E327928293B3628216C7C7C286C26266C3D3D5C27327A5C2729297B4728632069204B20242E332E';
wwv_flow_api.g_varchar2_table(34) := '61297B242E332E31312E3169282428372E6D292E6E28242E332E615B695D292E6F297D7D682036286C26266C3D3D5C2731355C27297B4728632069204B20242E332E61297B3628242E332E313828242E332E615B695D2929242E332E31312E3169282428';
wwv_flow_api.g_varchar2_table(35) := '372E6D292E6E28242E332E615B695D292E6F297D7D682036286C26266C3D3D5C27615C272626242E3261286129297B4728632069204B2061297B242E332E31312E3169282428372E6D292E6E28615B695D292E6F297D7D242E332E712E316F28242E332E';
wwv_flow_api.g_varchar2_table(36) := '3131297D7D2C533A622835297B2428372E6D292E6E28352E732C35293B242E332E612E5628352E73297D2C31383A622835297B72202428372E6D292E6E2835292E324328297D2C32443A622835297B3628242E332E3138283529297B2428372E6D292E6E';
wwv_flow_api.g_varchar2_table(37) := '2835292E316E2870293B6320653D2428372E6D292E6E28352B5C27655C27293B3628652E49297B652E313728293B652E493D707D7D68202428372E6D292E6E2835292E316E2875297D2C31703A6228297B7220242E332E612E31657D2C31713A6228297B';
wwv_flow_api.g_varchar2_table(38) := '7220242E332E31302E31657D2C32453A6228297B632031483D303B4728632069204B20242E332E61297B3628242E332E313828242E332E615B695D29297B31482B2B7D7D722031487D2C32473A6228352C32297B632031493D2428372E6D292E6E283529';
wwv_flow_api.g_varchar2_table(39) := '3B4820322E733B4820322E31353B3628322E6B297B63204C3D322E6B3B4820322E6B3B36284C26264C3D3D5C2732375C27297B3628372E382E6B2626372E382E6B2E52297B322E6B3D372E382E6B2E523B3628372E382E6B2E4629322E463D372E382E6B';
wwv_flow_api.g_varchar2_table(40) := '2E467D68203628372E382E6B29322E6B3D372E382E6B7D682036284C26264C2E52297B322E6B3D4C2E523B36284C2E4629322E463D4C2E467D682036284C29322E6B3D4C7D3628322E74297B242E332E5028322E742C702C7B423A31497D293B4820322E';
wwv_flow_api.g_varchar2_table(41) := '743B4820322E413B4820322E793B4820322E6F7D68203628322E412626322E797C7C322E6F297B362821322E6F29322E6F3D7820672E662E5428322E412C322E79297D31492E31452832297D2C324E3A62286C297B63204D3D5B5D3B3250286C297B3262';
wwv_flow_api.g_varchar2_table(42) := '223252223A4728632069204B20242E332E61297B6320583D225C27222B692B225C273A205C27222B2428372E6D292E6E28242E332E615B695D292E316628292E314E28292B225C27223B4D2E562858297D72227B5C27615C273A7B222B4D2E326628222C';
wwv_flow_api.g_varchar2_table(43) := '22292B227D7D223B314F3B3262226E223A4728632069204B20242E332E61297B6320583D22355B222B692B225D3D222B2428372E6D292E6E28242E332E615B695D292E316628292E314E28293B4D2E562858297D72204D2E326628222622293B314F3B32';
wwv_flow_api.g_varchar2_table(44) := '373A4728632069204B20242E332E61297B6320583D2428372E6D292E6E28242E332E615B695D292E316628292E314E28293B4D2E562858297D72204D3B314F7D7D2C31743A622835297B632031613D242E325928352C242E332E61292C31503B36283161';
wwv_flow_api.g_varchar2_table(45) := '3E2D31297B242E332E31302E326A2831612C31293B31503D242E332E612E326A2831612C31293B6320423D31505B305D3B6320353D2428372E6D292E6E2842293B6320653D2428372E6D292E6E28422B5C27655C27293B352E316E2870293B352E313228';
wwv_flow_api.g_varchar2_table(46) := '7A293B2428372E6D292E31682842293B362865297B652E313728293B652E493D703B2428372E6D292E316828422B5C27655C27297D7220757D7220707D2C33323A6228297B4728632069204B20242E332E61297B6320423D242E332E615B695D3B632035';
wwv_flow_api.g_varchar2_table(47) := '3D2428372E6D292E6E2842293B6320653D2428372E6D292E6E28422B5C27655C27293B352E316E2870293B352E3132287A293B2428372E6D292E31682842293B362865297B652E313728293B652E493D703B2428372E6D292E316828422B5C27655C2729';
wwv_flow_api.g_varchar2_table(48) := '7D7D242E332E316A3D703B242E332E613D5B5D3B242E332E31303D5B5D7D2C33333A6228297B63204D3D5B5D3B4728632069204B20242E332E61297B3628242E332E326C282428372E6D292E6E28242E332E615B695D292E3166282929294D2E5628242E';
wwv_flow_api.g_varchar2_table(49) := '332E615B695D297D72204D7D2C326C3A6228326E297B7220242E332E712E314428292E333628326E297D2C31393A622835297B6320323D7B713A372E717D3B372E31432B2B3B3628352E7329322E733D352E733B6820322E733D372E382E32632B372E31';
wwv_flow_api.g_varchar2_table(50) := '433B242E332E31302E5628322E73293B3628352E31353D3D7029322E31353D352E31353B3628352E315229322E31523D352E31523B3628352E313329322E31333D352E31333B3628352E6B2626352E6B2E52297B322E6B3D352E6B2E523B3628352E6B2E';
wwv_flow_api.g_varchar2_table(51) := '4629322E463D352E6B2E467D68203628352E6B29322E6B3D352E6B3B68203628372E382E6B2626372E382E6B2E52297B322E6B3D372E382E6B2E523B3628372E382E6B2E4629322E463D372E382E6B2E467D68203628372E382E6B29322E6B3D372E382E';
wwv_flow_api.g_varchar2_table(52) := '6B3B3628352E74297B3628352E6429322E643D352E643B242E332E5028352E742C702C32297D68203628352E412626352E797C7C352E6F297B3628352E6F29322E6F3D352E6F3B6820322E6F3D7820672E662E5428352E412C352E79293B6320513D7820';
wwv_flow_api.g_varchar2_table(53) := '672E662E32312832293B3628352E64297B362821352E642E4A262621352E642E3136262621352E642E7329352E643D7B4A3A352E647D3B6820362821352E642E4A29352E642E4A3D7A3B242E332E317928512C352E64297D242E332E532851293B722051';
wwv_flow_api.g_varchar2_table(54) := '7D7D7D7D29283242293B272C36322C3139352C277C7C6F7074696F6E737C676F4D61707C7C6D61726B65727C69667C746869737C6F7074737C7C6D61726B6572737C66756E6374696F6E7C7661727C68746D6C7C696E666F7C6D6170737C676F6F676C65';
wwv_flow_api.g_varchar2_table(55) := '7C656C73657C7C7C69636F6E7C747970657C6D617049647C646174617C706F736974696F6E7C66616C73657C6D61707C72657475726E7C69647C616464726573737C747275657C696E666F77696E646F777C6576656E747C6E65777C6C6F6E6769747564';
wwv_flow_api.g_varchar2_table(56) := '657C6E756C6C7C6C617469747564657C6D61726B657249647C6D617054797065436F6E74726F6C4F7074696F6E737C7374796C657C6E617669676174696F6E436F6E74726F6C4F7074696F6E737C736861646F777C666F727C64656C6574657C73686F77';
wwv_flow_api.g_varchar2_table(57) := '7C636F6E74656E747C696E7C746F7074696F6E7C61727261797C6576616C7C746F5570706572436173657C67656F636F64657C636D61726B65727C696D6167657C6164644D61726B65727C4C61744C6E677C63656E7465724C61744C6E677C707573687C';
wwv_flow_api.g_varchar2_table(58) := '6164644C697374656E65727C74656D707C7461726765747C4D794F7665726C61797C746D704D61726B6572737C626F756E64737C7365744D61707C647261676761626C657C7374617475737C76697369626C657C616A61787C636C6F73657C6765745669';
wwv_flow_api.g_varchar2_table(59) := '7369626C654D61726B65727C6372656174654D61726B65727C696E6465787C746578747C47656F636F6465725374617475737C64656C61797C6C656E6774687C676574506F736974696F6E7C726573756C74737C72656D6F7665446174617C657874656E';
wwv_flow_api.g_varchar2_table(60) := '647C73696E676C654D61726B65727C436F6E74726F6C506F736974696F6E7C64656661756C74737C70726F746F747970657C73657456697369626C657C666974426F756E64737C6765744D61726B6572436F756E747C676574546D704D61726B6572436F';
wwv_flow_api.g_varchar2_table(61) := '756E747C73657454696D656F75747C73657443656E7465727C72656D6F76654D61726B65727C4F4B7C67656F6D657472797C6C6F636174696F6E7C636C69636B7C736574496E666F57696E646F777C6F70656E57696E646F777C6F70656E7C736574436F';
wwv_flow_api.g_varchar2_table(62) := '6E74656E747C636F756E747C676574426F756E64737C7365744F7074696F6E737C73747265657456696577436F6E74726F6C7C64697361626C65446F75626C65436C69636B5A6F6F6D7C76636F756E747C746D61726B65727C7363726F6C6C776865656C';
wwv_flow_api.g_varchar2_table(63) := '7C7363616C65436F6E74726F6C7C6D617054797065436F6E74726F6C7C6E617669676174696F6E436F6E74726F6C7C746F55726C56616C75657C627265616B7C63757272656E747C7A6F6F6D7C7469746C657C72656D6F76654C697374656E65727C6874';
wwv_flow_api.g_varchar2_table(64) := '6D6C5F617070656E647C686964654469767C6469767C6C697374656E65727C747970656F667C68746D6C5F70726570656E647C6D6170747970657C4E617669676174696F6E436F6E74726F6C5374796C657C4D61726B65727C6D61705479706549647C4D';
wwv_flow_api.g_varchar2_table(65) := '617054797065436F6E74726F6C5374796C657C7C63656E7465727C6F626A6563747C64656661756C747C6D794F7074696F6E737C44454641554C547C697341727261797C636173657C70726566697849647C6F6E65496E666F57696E646F777C64626C63';
wwv_flow_api.g_varchar2_table(66) := '6C69636B7C6A6F696E7C6F7665726C61797C686964654279436C69636B7C636C656172496E666F7C73706C6963657C6C61744C6E677C697356697369626C657C6372656174654C697374656E65727C6C61746C6E677C696E69747C67656F636F6465727C';
wwv_flow_api.g_varchar2_table(67) := '4D61707C676F6D61704D61726B65727C676574496E666F7C676574436F6E74656E747C736574496E666F7C666E7C6D756C74697C544F505F4C4546547C4C61744C6E67426F756E64737C616C6C7C47656F636F6465727C6A51756572797C676574566973';
wwv_flow_api.g_varchar2_table(68) := '69626C657C73686F77486964654D61726B65727C67657456697369626C654D61726B6572436F756E747C544F505F52494748547C7365744D61726B65727C4F7665726C6179566965777C3530307C736574506F736974696F6E7C6F6E4164647C73696E67';
wwv_flow_api.g_varchar2_table(69) := '6C657C646972656374696F6E737C6765744D61726B6572737C6765744D61707C7377697463687C646972656374696F6E73526573756C747C6A736F6E7C6F6E52656D6F76657C4F5645525F51554552595F4C494D49547C647261777C496E666F57696E64';
wwv_flow_api.g_varchar2_table(70) := '6F777C656163687C706F7075707C696E41727261797C4859425249447C676F6D61726B65727C35367C636C6561724D61726B6572737C67657456697369626C654D61726B6572737C4D61705479706549647C75726C7C636F6E7461696E737C7375636365';
wwv_flow_api.g_varchar2_table(71) := '73737C636C617373272E73706C697428277C27292C302C7B7D2929';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(71172792027477932258)
,p_plugin_id=>wwv_flow_api.id(71172791097624928973)
,p_file_name=>'jquery.gomap-1.2.2.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
