<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }                
            </style>
            <script  type="text/javascript">
                function cogerId(obj){
                    alert(obj);


                }                

                function getCodigoProceso(codCompProd,codProgramaProduccion,codFormulaMaestra,codLoteProduccion,codTipoActividadProduccion,codTipoProgramaProd){
                 //  alert(codigo);
                 //alert(codComProd + ' '+ codProgramaProduccion + ' '+ codFormulaMaestra + ' '+  codLoteProduccion + ' '+  codTipoActividadProduccion);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codCompProd='+codCompProd+'&codProgramaProduccion='+codProgramaProduccion+'&codFormulaMaestra='+codFormulaMaestra+'&codLoteProduccion='+codLoteProduccion+'&codTipoActividadProduccion='+codTipoActividadProduccion+'&codTipoProgramaProd='+codTipoProgramaProd;

                }
                function getCodigoProcesoMicrobiologia(codComProd,codigo,codFormula,codLote,codTipoActividadProduccion){
                 //  alert(codigo);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codigo='+codigo+'&cod_formula='+codFormula+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoProcesoControlDeCalidad(codComProd,codigo,codFormula,codLote,codTipoActividadProduccion){
                 //  alert(codigo);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codigo='+codigo+'&cod_formula='+codFormula+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigo(codigo,codFormula,nombre,cantidad,codComProd,codLote,codTipoProgramaProd){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                    url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoProgramaProd='+codTipoProgramaProd;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

                }
                function getCodigo1(codComProd,codigo,codFormula,codLote){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    url='../barcode?number=1&location='+codComProd+"-"+codigo+"-"+codFormula+"-"+codLote;
                    //url='../codigo_barras.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

                }
                function getCodigo2(codProgProd,codFormula,nombre,cantidad,codComProd,codLote){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                    url='imprimir_programa_prod_excel.jsf?codProgProd='+codProgProd+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                    alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){


                    location='../reporteExplosionProductos/guardarReservaProgramaProd.jsf?codigo='+codigo;


                }

                function editarItem(nametable){
                    var count=0;
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel=cellsElement[0];
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel.getElementsByTagName('input')[0].checked){
                                count++;
                            }

                        }

                    }
                    if(count==1){
                        return true;
                    } else if(count==0){
                        alert('No escogio ningun registro');
                        return false;
                    }
                    else if(count>1){
                        alert('Solo puede escoger un registro');
                        return false;
                    }
                }


                function asignar(nametable){

                    var count=0;
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel=cellsElement[0];
                        alert('hola');
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel.getElementsByTagName('input')[0].checked){
                                count++;
                            }
                        }
                    }
                    if(count==0){
                        alert('No selecciono ningun Registro');
                        return false;
                    }else{
                        if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }

                    }

                }

                function eliminar(nametable){
                    var count1=0;
                    var elements1=document.getElementById(nametable);
                    var rowsElement1=elements1.rows;
                    //alert(rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[0];
                        if(cel1.getElementsByTagName('input').length>0){
                            if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                                if(cel1.getElementsByTagName('input')[0].checked){
                                    count1++;
                                }
                            }
                        }

                    }
                    //alert(count1);
                    if(count1==0){
                        alert('No escogio ningun registro');
                        return false;
                    }
                    if(count1>1){
                        alert('Debe escoger solo un registro');
                        return false;
                    }
                    return true;
                }

                /* else{


                        if(confirm('Desea Eliminar el Registro')){
                            if(confirm('Esta seguro de Eliminar el Registro')){
                                var count=0;
                                var elements=document.getElementById(nametable);
                                var rowsElement=elements.rows;

                                for(var i=0;i<rowsElement.length;i++){
                                    var cellsElement=rowsElement[i].cells;
                                    var cel=cellsElement[0];
                                    if(cel.getElementsByTagName('input').length>0){
                                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                            if(cel.getElementsByTagName('input')[0].checked){
                                                count++;
                                            }
                                        }
                                    }

                                }
                                if(count==0){
                                    //alert('No escogio ningun registro');
                                    return false;
                                }
                                //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                                //cantidadeliminar.value=count;
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }
                    } */
                
                function reserva(nametable){
                    var count1=0;
                    var elements1=document.getElementById(nametable);
                    var rowsElement1=elements1.rows;
                    //alert(rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[0];
                        if(cel1.getElementsByTagName('input').length>0){
                            if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                                if(cel1.getElementsByTagName('input')[0].checked){
                                    count1++;
                                }
                            }
                        }

                    }
                    //alert(count1);
                    if(count1==0){
                        alert('No escogio ningun registro');
                        return false;
                    }else{


                        if(confirm('Desea Realizar la Reserva del Producto')){
                            if(confirm('Esta seguro de Realizar la Reserva ')){
                                var count=0;
                                var elements=document.getElementById(nametable);
                                var rowsElement=elements.rows;

                                for(var i=0;i<rowsElement.length;i++){
                                    var cellsElement=rowsElement[i].cells;
                                    var cel=cellsElement[0];
                                    if(cel.getElementsByTagName('input').length>0){
                                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                            if(cel.getElementsByTagName('input')[0].checked){
                                                count++;
                                            }
                                        }
                                    }

                                }
                                if(count==0){
                                    //alert('No escogio ningun registro');
                                    return false;
                                }
                                //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                                //cantidadeliminar.value=count;
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }
                    }
                }

                 function eliminarReserva(nametable){
                    var count1=0;
                    var elements1=document.getElementById(nametable);
                    var rowsElement1=elements1.rows;
                    //alert(rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[0];
                        if(cel1.getElementsByTagName('input').length>0){
                            if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                                if(cel1.getElementsByTagName('input')[0].checked){
                                    count1++;
                                }
                            }
                        }

                    }
                    //alert(count1);
                    if(count1==0){
                        alert('No escogio ningun registro');
                        return false;
                    }else{


                        if(confirm('Desea Eliminar la Reserva del Producto')){
                            if(confirm('Esta seguro de Eliminar la Reserva')){
                                var count=0;
                                var elements=document.getElementById(nametable);
                                var rowsElement=elements.rows;

                                for(var i=0;i<rowsElement.length;i++){
                                    var cellsElement=rowsElement[i].cells;
                                    var cel=cellsElement[0];
                                    if(cel.getElementsByTagName('input').length>0){
                                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                            if(cel.getElementsByTagName('input')[0].checked){
                                                count++;
                                            }
                                        }
                                    }

                                }
                                if(count==0){
                                    //alert('No escogio ningun registro');
                                    return false;
                                }
                                //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                                //cantidadeliminar.value=count;
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }
                    }
                }
                
                function nuevoAjax()
                {	var xmlhttp=false;
                    try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (E) {
                            xmlhttp = false;
                        }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                        xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
                }
                function enviar(codigo,fecha_ini,fecha_fin){
                    //alert();

                    var ajax=nuevoAjax();
                    var valores='codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin;
                    valores+='&pq='+(Math.random()*1000);

                    var url='../reporteExplosionProductos/filtroReporteExplosion.jsf';



                    //alert(url);
                    ajax.open ('POST', url, true);
                    ajax.onreadystatechange = function() {

                        if (ajax.readyState==1) {

                        }else if(ajax.readyState==4){
                            // alert(ajax.status);
                            if(ajax.status==200){
                                //alert(ajax.responseText);
                                var mainGrupo=document.getElementById('panelCenter');
                                //mainGrupo.innerHTML=ajax.responseText;
                                document.write(ajax.responseText);

                                //f=0;
                                //Item(codigo,f);
                            }
                        }
                    }
                    ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
                    ajax.send(valores);
                }


                function seleccionarTodo(){
                    //alert('entro');
                    var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
                    var elements=document.getElementById('form1:dataFormula');

                    if(seleccionar_todo.checked==true){
                        //alert('entro por verdad');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=true;
                            }
                        }
                    }
                    else
                    {//alert('entro por false');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=false;
                            }
                        }

                    }
                    return true;

                }

                function validarSeleccion(nametable){
                    var count1=0;
                    var elements1=document.getElementById(nametable);
                    var rowsElement1=elements1.rows;
                    //alert(rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[0];
                        if(cel1.getElementsByTagName('input').length>0){
                            if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                                if(cel1.getElementsByTagName('input')[0].checked){
                                    count1++;
                                }
                            }
                        }

                    }
                    //alert(count1);
                    if(count1==0){
                        alert('No escogio ningun registro');
                        return false;
                    }
                }
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
         </script>
        </head>
        <%--<body onLoad="window.defaultStatus='Hola, yo soy la barra de estado.';">--%>
            
            
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarProgramaProduccionControlCalidad}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    <h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo();"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" />
                    <br> <br>
                        <h:panelGroup id="contenidoProgramaProduccion">
                            <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value=""  />

                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.checked}"   />

                                        </rich:column >

                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Producto"  />
                                            </f:facet>
                                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                                        </rich:column>
                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Lote"  />
                                            </f:facet>
                                            <h:outputText value="#{data.cantidadLote}"  />
                                        </rich:column>

                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Nro de Lote"  />
                                            </f:facet>
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </rich:column >
                                        
                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Inicial"  />
                                            </f:facet>
                                            <h:outputText value="#{data.fechaInicial}"  />
                                        </rich:column >
                                        
                                        <rich:column  styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Programa Producción"  />
                                            </f:facet>
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                                        </rich:column >

                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header" >
                                                <h:outputText value="Area"  />
                                            </f:facet>
                                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                        </rich:column>

                                        <rich:column  styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Observaciones"  />
                                            </f:facet>
                                            <h:outputText value="#{data.observacion}" />
                                        </rich:column >
                                        <rich:column  styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                        </rich:column >
                                        <rich:column styleClass="#{data.styleClass}" >
                                            <f:facet name="header">
                                                <h:outputText value=""  />
                                            </f:facet>
                                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codProgramaProduccion}','#{data.formulaMaestra.codFormulaMaestra}','#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}','#{data.formulaMaestra.cantidadLote}','#{data.formulaMaestra.componentesProd.codCompprod}','#{data.codLoteProduccion}','#{data.tiposProgramaProduccion.codTipoProgramaProd}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Detalle'></a>  "  escape="false"  />
                                        </rich:column >
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Proceso Producción"  />
                                            </f:facet>
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="96" />
                                                <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
                                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                                            </h:commandLink>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Proceso Microbiologia"  />
                                            </f:facet>
                                             <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="75" />
                                                <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
                                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                                            </h:commandLink>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Proceso Control de Calidad"  />
                                            </f:facet>
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="40" />
                                                <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
                                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                                            </h:commandLink>
                                        </rich:column>

                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Proceso Acondicionamiento"  />
                                            </f:facet>
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="84" />
                                                <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
                                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                                            </h:commandLink>
                                        </rich:column>

                        </rich:dataTable>
                    
                    <br>                        
                    <h:commandButton value="Agregar" action="#{ManagedProgramaProduccion.agregarProgramaProduccion_action}"  styleClass="btn"  /> <%--  action="#{ManagedProgramaProduccion.actionagregar}" oncomplete="location='navegador_programa_produccion_lotes.jsf'" --%>
                    <h:commandButton value="Editar Lote"    styleClass="btn"  action="#{ManagedProgramaProduccion.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarProgProd}" onclick="if(confirm('Esta seguro de eliminar el registro?')==false){return false}"/><%-- else{return eliminar('form1:dataFormula');} --%>
                    <h:commandButton value="Reservar"    styleClass="btn"  action="#{ManagedProgramaProduccion.guardarReserva}" onclick="return reserva('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar Reserva"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarReserva}" onclick="return eliminarReserva('form1:dataFormula');"/>
                    <a4j:commandButton value="Terminar Producto" styleClass="btn" oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){javascript:Richfaces.showModalPanel('panelActividadesProducto',{width:100, top:100});}else{javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');}" 
                                       action="#{ManagedProgramaProduccion.terminarProducto_action}"
                                       reRender="contenidoActividadesProducto,contenidoIngresoAcondicionamiento"/>
                    <h:commandButton value="Registrar Actividades Indirectas" action="#{ManagedProgramaProduccion.agregarSeguimientoIndirectas_action}"  styleClass="btn"  />
                    </h:panelGroup>
                   
                    

                    
                    <%--a4j:commandButton value="Explosión"  styleClass="btn"  action="#{ManagedProgramaProduccion.actionEliminar}"  oncomplete="enviar('#{ManagedProgramaProduccion.codigos}','#{ManagedProgramaProduccion.fecha_inicio}','#{ManagedProgramaProduccion.fecha_final}')" /--%>
                </div>

                <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />


            </a4j:form>
            
            
                    
                <%--h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="Nº Ingreso :" styleClass="outputTextTitulo"  />
                            <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.nroIngresoAcond}"  id="nroIngresoAcond"  /--%>

                
                    

                        <%--final ale devoluciones--%>

            
        </body>
    </html>
    
</f:view>

