package programaProduccion_1;

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
                function getCodigoProcesoProduccion(codComProd,codigo,codFormula,codLote,codTipoActividadProduccion){
                 //  alert(codigo);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codigo='+codigo+'&cod_formula='+codFormula+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoProcesoMicrobiologia(codComProd,codigo,codFormula,codLote,codTipoActividadProduccion){
                 //  alert(codigo);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codigo='+codigo+'&cod_formula='+codFormula+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoProcesoControlDeCalidad(codComProd,codigo,codFormula,codLote,codTipoActividadProduccion){
                 //  alert(codigo);
                   location='../actividades_programa_produccion/navegador_actividades_programa.jsf?codigo='+codigo+'&cod_formula='+codFormula+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigo(codigo,codFormula,nombre,cantidad,codComProd,codLote){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                    url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
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
                    }else{


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
                    }
                }
                
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
                    var elements=document.getElementById('form1:dataProgramaProduccion');

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
                function seleccionarItem(nametable){
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
                function seleccionarTipoSalida_action(){
                    window.location = 'navegador_programa_produccion.jsf?seleccionoTipoSalidaAlmacenProduccion=1';                    

                }
         </script>
        </head>
        <%-- onbeforedomupdate="alert('hola')" onLoad="window.defaultStatus='Hola, yo soy la barra de estado.';" --%>
        <body   > <%-- onload="Richfaces.showModalPanel('panelTipoSalidaAlmacenProduccion');" --%>
            <a4j:form id="form1" onreset="alert('hola')"  oncomplete="Richfaces.showModalPanel('panelTipoSalidaAlmacenProduccion');" >
                <rich:panel id="panelEstadoCuentas" styleClass="panelBuscar" style="top:50px;left:50px;width:700px;">
                    <f:facet name="header">
                        <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelEstadoCuentas');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"document.getElementById('form1:panelEstadoCuentas').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                              escape="false" />
                    </f:facet>
                </rich:panel>
                
                <div align="center">
                    
                    
                    <h:outputText value="#{ManagedProgramaProduccion.cargarContenidoProgramaProduccionPeriodo}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    

                        <br>
                    <%--h:outputText styleClass="outputTextTitulo"  value="Estado::" />
                    <h:selectOneMenu value="#{ManagedProgramaProduccion.formulaMaestrabean.estadoRegistro.codEstadoRegistro}" styleClass="inputText"
                                     valueChangeListener="#{ManagedFormulaMaestra.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataProgramaProduccion"  />
                    </h:selectOneMenu--%>
                    
                    
                    <%--h:outputText styleClass="outputTextTitulo"  value="Area ::" />
                    <h:selectOneMenu value="#{ManagedProgramaProduccion.codAreaProgramaProduccion}" styleClass="inputText"
                                     valueChangeListener="#{ManagedProgramaProduccion.areaProduccion_changed}">
                                     <f:selectItems value="#{ManagedProgramaProduccion.areaProgramaProduccionList}"  />
                        <a4j:support event="onchange"  reRender="dataProgramaProduccion"  />
                    </h:selectOneMenu--%>
                    
                    <%--br> <br--%>
                    <%--h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo();"/--%>
                    <%--h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" /--%>
                    <%--br> <br--%>
                        <br>Buscar
                        <a4j:commandLink action="#{ManagedProgramaProduccion.buscarLoteProduccion_action}" oncomplete="Richfaces.showModalPanel('panelBuscarLoteProduccion')" >
                                <h:graphicImage url="../img/buscar.png" />
                        </a4j:commandLink>
                        <div style="overflow:auto;text-align:center;height:400px;" id="main">
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionPeriodoList}" var="data" id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccion.programaProduccionPeriodoDataTable}"
                                    style="width=100%"
                                    >
                        <%--rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"   />
                            
                        </rich:column --%>
                        
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <a4j:commandLink styleClass="outputText2" onclick="location='navegador_seguimiento_programa_produccion.jsf?codProgramaProd=#{data.codProgramaProduccion}'">
                            <h:outputText value="#{data.nombreProgramaProduccion}"  />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column>
                                                

                    </rich:dataTable>
                    </h:panelGroup>
                    </div>
                    <br/>

                    <%--h:commandButton  value=" Generar Salidas de Almacen "
                    onclick="if(seleccionarItem('form1:dataProgramaProduccion')==false){return false;}" styleClass="btn"                    
                    action="#{ManagedProgramaProduccion.generarSalidaAlmacenes_action}"
                     /--%>


                    
                   
                    
                    
                    <%--a4j:commandButton value="Explosión"  styleClass="btn"  action="#{ManagedProgramaProduccion.actionEliminar}"  oncomplete="enviar('#{ManagedProgramaProduccion.codigos}','#{ManagedProgramaProduccion.fecha_inicio}','#{ManagedProgramaProduccion.fecha_final}')" /--%>
                </div>

                <%--a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel--%>

                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />


            </a4j:form>
            
            <%--rich:modalPanel id="panelTipoSalidaAlmacenProduccion"  minHeight="120"  minWidth="400"
                                     height="120" width="400"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Tipo Salida Almacen Programa Produccion"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoTipoSalidaAlmacenProduccion">
                            <h:panelGrid columns="2">
                                <h:outputText value="Tipo Salida Almacen :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedProgramaProduccion.configuracionSalidaAlmacenProduccion.tiposSalidaAlmacenProduccion.codTipoSalidaAlmacenProduccion}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.tiposSalidasMaterialList}" />
                                </h:selectOneMenu>                              
                            </h:panelGrid>
                                <div align="center">
                                
                                 <a4j:commandButton value="Aceptar" action="#{ManagedProgramaProduccion.seleccionarTipoSalidaAlmacen}"
                                 onclick="Richfaces.hideModalPanel('panelTipoSalidaAlmacenProduccion')"
                                 reRender="contenidoProgramaProduccion" styleClass="btn"/>

                                
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel--%>
            <rich:modalPanel id="panelBuscarLoteProduccion"  minHeight="120"  minWidth="300"
                                     height="120" width="300"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Buscar Lote de Produccion "/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoBuscarLoteProduccion">
                            <div align="center">
                            <h:panelGrid columns="2">
                                <h:outputText value="Lote :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedProgramaProduccion.programaProduccionBuscar.codLoteProduccion}" styleClass="inputText2" />

                            </h:panelGrid>
                                

                                 <a4j:commandButton value="Aceptar" onclick = "location ='navegador_seguimiento_programa_produccion.jsf'" styleClass="btn"/>
                                 <input value="Cancelar" onclick="Richfaces.hideModalPanel('panelBuscarLoteProduccion')" class="btn" type="button" />


                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

