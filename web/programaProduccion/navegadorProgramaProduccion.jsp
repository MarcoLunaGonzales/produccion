
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css"/>
            <script type="text/javascript" src="../js/general.js" ></script>
            
            <style  type="text/css">
                .a
                {
                background-color : #F2F5A9;
                }
                .b
                {
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
                .classDetalle td
                {
                    background-color:white;
                    border:1px solid #bbbbbb;
                    padding:4px;
                }
                .linea td
                {
                    border:1px solid #bbbbbb;
                    padding:4px;
                }
                .desviacion
                {
                    background-color:#fbcd98;
                    border: 2px solid #e6a75e;
                }
                .iconInfo
                {
                    width:24px;
                    height:24px
                }
                .tdTiempoRegistrado
                {
                    background-color: #b4f5b4;
                    border:2px solid #74bf74 ;
                }
                .tdTiempoRegistrado>span
                {
                    display: block;
                    font-weight: bold;
                }
                .tdOrdenManufacturaDeshabilitada{
                    background-color: #ffd2b4;
                    border:2px solid #ee9d68 ;
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
                function getCodigo(codigo,codFormula,cantidad,codComProd,codLote,codTipoProgramaProd){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                    url='reporteDetalleProgramaProduccion.jsf?codigo='+codigo+'&codFormula='+codFormula+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote+'&codTipoProgramaProd='+codTipoProgramaProd;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp'+(new Date()).getTime().toString(),opciones)

                }
                function getCodigo1(codComProd,codigo,codFormula,codLote){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100;
                    arriba = (screen.height) ? (screen.height-400)/2 : 200;
                    url='../barcode?number=1&location='+codComProd+"-"+codigo+"-"+codFormula+"-"+codLote;
                    //url='../codigo_barras.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp'+(new Date()).getTime().toString(),opciones)

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
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function iniciarEnvioAcond()
                {
                    if(!validarRegistroEntero(document.getElementById("panelIngresoAcondicionamiento:form2:cantidadIngreso")))
                        return false;
                    if(parseInt(document.getElementById("panelIngresoAcondicionamiento:form2:cantidadIngreso").value)<=0)
                    {
                        alert('La cantidad ingresada debe ser mayor a cero');
                        return false;
                    }
                    if(parseInt(document.getElementById("panelIngresoAcondicionamiento:form2:pesoIngreso").value)<=0)
                    {
                        alert('El peso debe ser mayor o igual a cero');
                        return false;
                    }

                    return true;
                    
                }
                function terminarEnvioAcond()
                {
                    document.getElementById("panelIngresoAcondicionamiento:form2:buttonEnvio").style.display='block';
                    document.getElementById("progress").style.display='none';
                }
                A4J.AJAX.onError = function(req,status,message){
                    window.alert("Ocurrio un error: "+message);
                    terminarEnvioAcond();
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            terminarEnvioAcond();
            }
        </script>
        </head>
           <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccion.cargarProgramaProducion}"  />
                    <h:outputText styleClass="outputTextTituloSistema" value="Programas de Producción" />
                     
                        <rich:panel headerClass="headerClassACliente" rendered="#{ManagedProgramaProduccion.programaProduccionFiltro.codLoteProduccion !=''}">
                            <f:facet name="header">
                                <h:outputText value="Busqueda"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Lote Busqueda"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionFiltro.codLoteProduccion}"/>
                            </h:panelGrid>
                        </rich:panel>
                        <rich:panel headerClass="headerClassACliente" rendered="#{ManagedProgramaProduccion.programaProduccionPeriodoBean!= null}">
                            <f:facet name="header">
                                <h:outputText value="Datos Programa Producción"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Nombre Programa"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionPeriodoBean.nombreProgramaProduccion}"/>
                                <h:outputText styleClass="outputTextBold" value="Observación"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionPeriodoBean.obsProgramaProduccion}"/>
                                <h:outputText styleClass="outputTextBold" value="Fecha Inicio"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionPeriodoBean.fechaInicio}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText styleClass="outputTextBold" value="Fecha Final"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionPeriodoBean.fechaFinal}">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                            </h:panelGrid>

                        </rich:panel>
                    <h:panelGroup id="contenidoProgramaProduccion">
                        <br>
                        <h:outputText value="<table cellpading='0' cellspacing='0'><tr><td class='tdTiempoRegistrado outputTextBold' style='padding:0.5em'>Lotes Sin O.M. Generada</td><td class='tdOrdenManufacturaDeshabilitada outputTextBold' style='padding:0.5em'>Lotes que se deben reprocesar</td></tr></table></br>" escape="false" rendered="#{ManagedProgramaProduccion.permisoImpresionOm}"/>

                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionList}"
                                    var="data" id="dataProgramaProduccion"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccion.programaProduccionDataTable}">
                                        <f:facet name="header">
                                    <rich:columnGroup>
                                        
                                            <rich:column rowspan="2">
                                                <h:outputText value=""/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Producto"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Cantidad.<br> Lote" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nro. Lote"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Fecha Registro"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Tipo Programa Producción"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.programaProduccionPeriodoBean eq null}">
                                                <h:outputText value="Tipo Programa Producción"/>
                                            </rich:column>
                                            <rich:column colspan="2">
                                                <h:outputText value="Nro Version"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Categoría"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Estado Materia Prima"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Area"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Observaciones"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Estado"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value=""/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Acciones"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.permisoImpresionEtiquetasMP||ManagedProgramaProduccion.permisoImpresionEtiquetasMpFecha}">
                                                <h:outputText value="Etiquetas<br>Pesaje" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.permisoGeneracionDesviacion}">
                                                <h:outputText value="Desviación <br> Material" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.permisoImpresionOm}">
                                                <h:outputText value="Orden<br>de<br>Manufactura" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="5" rendered="#{ManagedProgramaProduccion.permisoTiempoSoporteManufactura||ManagedProgramaProduccion.permisoTiemposProduccion||ManagedProgramaProduccion.permisoTiemposMicrobiologia||ManagedProgramaProduccion.permisoTiemposCC||ManagedProgramaProduccion.permisotiemposAcond}">
                                                <h:outputText value="Registro de Tiempos"/>
                                            </rich:column>
                                            
                                            <rich:column breakBefore="true">
                                                <h:outputText value="Producto"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="E.S."/>
                                            </rich:column>
                                            <rich:column  rendered="#{ManagedProgramaProduccion.permisoTiemposProduccion}">
                                                <h:outputText value="Producción"/>
                                            </rich:column>
                                            <rich:column rendered="#{ManagedProgramaProduccion.permisoTiemposMicrobiologia}">
                                                <h:outputText value="Microbiología"/>
                                            </rich:column>
                                            <rich:column rendered="#{ManagedProgramaProduccion.permisoTiemposCC}">
                                                <h:outputText value="Control de Calidad"/>
                                            </rich:column>
                                            <rich:column rendered="#{ManagedProgramaProduccion.permisotiemposAcond}">
                                                <h:outputText value="Acondicionamiento"/>
                                            </rich:column>
                                            <rich:column rendered="#{ManagedProgramaProduccion.permisoTiempoSoporteManufactura}">
                                                <h:outputText value="Soporte Manufactura"/>
                                            </rich:column>
                                            
                                            
                                    </rich:columnGroup>
                                    </f:facet>
                                        
                                    <rich:columnGroup styleClass="#{ManagedProgramaProduccion.permisoImpresionOm?
                                                                        (data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm  eq 0 ?'tdTiempoRegistrado':
                                                                        (data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm  eq 4 ?'tdOrdenManufacturaDeshabilitada':'')):''}">
                                        <rich:column >
                                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadoProgramaProduccion.codEstadoProgramaProd!='6'}"  />
                                        </rich:column>
                                        <rich:column  >
                                            <h:outputText  styleClass="outputText2" style="display:block;" value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                            <h:graphicImage rendered="#{data.estadosProgramaProduccionImpresionOm.codEstadoProgramaProduccionImpresionOm eq 1}" styleClass="iconInfo" url="../img/OM.jpg" alt="Orden de Manufactura Entregada" />
                                            <h:graphicImage rendered="#{data.cantidadDesviaciones>0}" styleClass="iconInfo" url="../img/desviacion.gif" alt="Desviación Planificada de Material" />
                                        </rich:column>
                                        <rich:column  >
                                            <h:outputText value="#{data.cantidadLote}"  />
                                        </rich:column>
                                        <rich:column  >
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </rich:column >
                                        <rich:column  >
                                            <h:outputText value="#{data.fechaRegistro}">
                                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                            </h:outputText>
                                        </rich:column >
                                        <rich:column   >
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                                        </rich:column >
                                        <rich:column   rendered="#{ManagedProgramaProduccion.programaProduccionPeriodoBean eq null}" >
                                            <h:outputText value="#{data.programaProduccionPeriodo.nombreProgramaProduccion}" />
                                        </rich:column >
                                        <rich:column   >
                                            <h:outputText value="#{data.componentesProdVersion.nroVersion}"  />
                                        </rich:column >
                                        <rich:column   >
                                            <h:outputText value="#{data.componentesProdVersion.nroVersion}.#{data.formulaMaestraEsVersion.nroVersion}"  />
                                        </rich:column>
                                        <rich:column   >
                                            <h:outputText value="#{data.categoriasCompProd.nombreCategoriaCompProd}"  />
                                        </rich:column >
                                        <rich:column  >
                                            <h:outputText value="#{data.materialTransito}" id="n" />
                                        </rich:column>
                                        <rich:column  >
                                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.observacion}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codProgramaProduccion}','#{data.formulaMaestra.codFormulaMaestra}','#{data.formulaMaestra.cantidadLote}','#{data.formulaMaestra.componentesProd.codCompprod}','#{data.codLoteProduccion}','#{data.tiposProgramaProduccion.codTipoProgramaProd}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Detalle'></a>  "  escape="false"  />
                                        </rich:column>
                                        <rich:column>
                                            <rich:dropDownMenu >
                                                <f:facet name="label">
                                                    <h:panelGroup>
                                                        <h:outputText value="Acciones"/>
                                                        <h:outputText styleClass="icon-menu3"/>
                                                    </h:panelGroup>
                                                </f:facet>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Historico del Lote"
                                                                onclick="abrirVentana('reporteProgramaProduccionLog.jsf?codProgramaProd=#{data.codProgramaProduccion}&codLoteProduccion=#{data.codLoteProduccion}')">
                                                </rich:menuItem>
                                                <rich:menuSeparator/>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Editar Lote" 
                                                                rendered="#{ManagedProgramaProduccion.permisoEditarLoteProducccion
                                                                            and data.estadoProgramaProduccion.codEstadoProgramaProd ne '6'}">
                                                    <a4j:support event="onclick" oncomplete="redireccionar('editarProgramaProduccion.jsf')" >
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Cancelar Lote" 
                                                                rendered="#{ManagedProgramaProduccion.permisoCancelacionLoteProduccion 
                                                                            and data.estadoProgramaProduccion.codEstadoProgramaProd eq '2'}">
                                                    <a4j:support event="onclick" reRender="dataCancelarLote"
                                                                 oncomplete="Richfaces.showModalPanel('panelCancelarLote')" >
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuSeparator/>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Terminar Producto" 
                                                                rendered="#{ManagedProgramaProduccion.permisoTerminarProducto
                                                                                and data.estadoProgramaProduccion.codEstadoProgramaProd eq '7'}">
                                                    <a4j:support event="onclick"
                                                                 action="#{ManagedProgramaProduccion.terminarProductoAction}"
                                                                 oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){Richfaces.showModalPanel('panelIngresoAcondicionamiento:panelIngresoAcondicionamiento');}else{alert('#{ManagedProgramaProduccion.mensaje}');}"
                                                                 reRender="contenidoActividadesProducto,contenidoIngresoAcondicionamiento">
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionIngresoAcond}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Terminar Producto Manualmente" 
                                                                rendered="#{ManagedProgramaProduccion.permisoTerminarProducto
                                                                                and data.estadoProgramaProduccion.codEstadoProgramaProd eq '7'}">
                                                    <a4j:support event="onclick" reRender="dataTerminarLoteManual"
                                                                 oncomplete="Richfaces.showModalPanel('panelTerminarLoteManual')" >
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionCabeceraEditar}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuItem  submitMode="none" icon="../img/apertura.jpg" value="Aperturar Lote de Producción" 
                                                                rendered="#{ManagedProgramaProduccion.permisoAperturaLoteProduccion
                                                                                and data.estadoProgramaProduccion.codEstadoProgramaProd eq '6'}">
                                                    <a4j:support event="onclick" reRender="contenidoAperturaLoteProduccion"
                                                                 action="#{ManagedProgramaProduccion.seleccionarAperturaLoteProgramaProduccion_action()}"
                                                                 oncomplete="Richfaces.showModalPanel('panelAperturaLoteProduccion')" >
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionApertura}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                                <rich:menuSeparator/>
                                                <rich:menuItem  submitMode="none" value="Modificar/Anular envio de producto" 
                                                                rendered="#{(ManagedProgramaProduccion.permisoEditarEnvioAcondicionamiento or 
                                                                                ManagedProgramaProduccion.permisoAnularEnvioAcondicionamiento)
                                                                                and ( data.estadoProgramaProduccion.codEstadoProgramaProd eq '6' 
                                                                                        or data.estadoProgramaProduccion.codEstadoProgramaProd eq '7')}">
                                                    <a4j:support event="onclick" reRender="contenidoEnviosRealizados"
                                                                 action="#{ManagedProgramaProduccion.seleccionarEdicionEnvionAcondicionamientoAction()}"
                                                                 oncomplete="Richfaces.showModalPanel('panelEnviosRealizados')" >
                                                        <f:setPropertyActionListener target="#{ManagedProgramaProduccion.programaProduccionIngresoAcond}"
                                                                                     value="#{data}"/>
                                                    </a4j:support>
                                                </rich:menuItem>
                                            </rich:dropDownMenu>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedProgramaProduccion.permisoImpresionEtiquetasMP}">
                                            <a4j:commandLink action="#{ManagedProgramaProduccion.verReporteEtiquetas_action}" oncomplete="openPopup('reporteEtiquetas.jsp')">
                                                <h:graphicImage url="../img/etiqueta.gif"  alt="Etiquetas" />
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedProgramaProduccion.permisoImpresionEtiquetasMpFecha}">
                                            <a4j:commandLink action="#{ManagedProgramaProduccion.verReporteEtiquetasCambioFecha_action}" reRender="contenidoCambioFechaPesaje" oncomplete="javascript:Richfaces.showModalPanel('panelCambioFechaPesaje');">
                                                <h:graphicImage url="../img/etiqueta.gif"  alt="Etiquetas" />
                                            </a4j:commandLink>
                                        </rich:column>

                                        <rich:column  styleClass="#{data.cantidadDesviaciones>0?'desviacion':''}" rendered="#{ManagedProgramaProduccion.permisoGeneracionDesviacion}">
                                            <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarProgramaProduccionDesviacion_action}" oncomplete="redireccionar('desviacionesProgramaProduccion/agregarDesviacionProgramaProduccion.jsf');">
                                                <h:graphicImage url="../img/desviacion.gif"  alt="Etiquetas" />
                                                
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rendered="#{ManagedProgramaProduccion.permisoImpresionOm}">
                                            <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarProgramaProduccionImpresionOm}" oncomplete="Richfaces.showModalPanel('panelImpresionOm');"
                                                             reRender="contenidoImpresionOm">
                                                <h:graphicImage url="../img/OM.jpg"  alt="Orden de Manufactura" />
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter #{data.horasProduccion>0?'tdTiempoRegistrado':''}" rendered="#{ManagedProgramaProduccion.permisoTiemposProduccion}">
                                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}"
                                            rendered="#{data.formulaMaestra.componentesProd.forma.codForma != 2}"><%----%>
                                                <f:param name="codAreaEmpresa" value="96" />
                                                <f:param name="url" value="../programaProduccion/navegadorProgramaProduccion.jsf" />
                                                <h:graphicImage url="../img/registroTiempos.jpg" alt="Producción" />
                                            </a4j:commandLink>
                                            <h:outputText value="#{data.horasProduccion}" styleClass="outputText2" rendered="#{data.horasProduccion>0}">
                                                <f:convertNumber pattern="###0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter #{data.horasMicrobiologia>0?'tdTiempoRegistrado':''}" rendered="#{ManagedProgramaProduccion.permisoTiemposMicrobiologia}">
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="75" />
                                                <f:param name="url" value="../programaProduccion/navegadorProgramaProduccion.jsf" />
                                                <h:graphicImage url="../img/registroTiempos.jpg" alt="Microbiologia" />
                                            </h:commandLink>
                                            <h:outputText value="#{data.horasMicrobiologia}" styleClass="outputText2" rendered="#{data.horasMicrobiologia>0}">
                                                <f:convertNumber pattern="###0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter #{data.horasControlCalidad>0?'tdTiempoRegistrado':''}" rendered="#{ManagedProgramaProduccion.permisoTiemposCC}">
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" rendered="false">
                                                <f:param name="codAreaEmpresa" value="40" />
                                                <f:param name="url" value="../programaProduccion/navegadorProgramaProduccion.jsf" />
                                                <h:graphicImage url="../img/registroTiempos.jpg" alt="Control de Calidad" />
                                            </h:commandLink>
                                            <h:outputText value="#{data.horasControlCalidad}" styleClass="outputText2" rendered="#{data.horasControlCalidad>0}">
                                                <f:convertNumber pattern="###0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter #{data.horasAcondicionamiento>0?'tdTiempoRegistrado':''}" rendered="#{ManagedProgramaProduccion.permisotiemposAcond}">
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="84" />
                                                <f:param name="url" value="../programaProduccion/navegadorProgramaProduccion.jsf" />
                                                <h:graphicImage url="../img/registroTiempos.jpg" alt="Acondicionamiento" />
                                            </h:commandLink>
                                            <h:outputText value="#{data.horasAcondicionamiento}" styleClass="outputText2" rendered="#{data.horasAcondicionamiento>0}">
                                                <f:convertNumber pattern="###0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                        <rich:column styleClass="tdCenter #{data.horasSoporteManufactura>0?'tdTiempoRegistrado':''}" rendered="#{ManagedProgramaProduccion.permisoTiempoSoporteManufactura}">
                                            <h:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}" >
                                                <f:param name="codAreaEmpresa" value="1010" />
                                                <f:param name="url" value="../programaProduccion/navegadorProgramaProduccion.jsf" />
                                                <h:graphicImage url="../img/registroTiempos.jpg" alt="Soporte a la manufactura"  />
                                            </h:commandLink>
                                            <h:outputText value="#{data.horasSoporteManufactura}" styleClass="outputText2" rendered="#{data.horasSoporteManufactura>0}">
                                                <f:convertNumber pattern="###0.00" locale="en"/>
                                            </h:outputText>
                                        </rich:column>
                                    </rich:columnGroup>
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar" rendered="#{ManagedProgramaProduccion.programaProduccionPeriodoBean!=null&&ManagedProgramaProduccion.permisoGeneracionLotes}" oncomplete="window.location.href='agregarProgramaProduccion.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
                    
                    <h:commandButton value="Registrar Actividades Indirectas" rendered="#{ManagedProgramaProduccion.programaProduccionPeriodoBean!=null}" action="#{ManagedProgramaProduccion.agregarSeguimientoIndirectas_action}"  styleClass="btn"  />
                    <a4j:commandButton value="Volver" oncomplete="window.location.href='navegadorProgramaPeriodo.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
                    
                    </h:panelGroup>
                   
                    

                    <rich:modalPanel id="panelActividadesProducto" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100" headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Observaciones Producto" />
                        </f:facet>
                        <div align="center">
                        <h:panelGroup id="contenidoActividadesProducto">                        
                        <h:outputText value="#{ManagedProgramaProduccion.mensajes}" />
                        
                            <rich:dataTable  value="#{ManagedProgramaProduccion.actividadesProgramaProduccionList}"
                                         width="100%"  var="fila"                                         
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        
                                         id="actividadesProducto" rows="5"  align="center">
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Orden"/>
                                </f:facet>
                                <h:outputText value="#{fila.ordenActividad} "/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Actividad"/>
                                </f:facet>
                                <h:outputText value="#{fila.nombreActividad} "/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Tiempos"/>
                                </f:facet>
                                <rich:dataTable value="#{fila.seguimientoProgramaProduccionList}" var="fila1">
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Inicio"/>
                                            </f:facet>
                                            <h:outputText value="#{fila1.fechaInicio} "  />
                                        </rich:column>
                                        <rich:column >
                                             <f:facet name="header">
                                                <h:outputText value="Fecha Final"  />
                                            </f:facet>
                                            <h:outputText value="#{fila1.fechaFinal} "  />
                                        </rich:column>
                                        <rich:column >
                                               <f:facet name="header">
                                                <h:outputText value="Horas Hombre"  />
                                            </f:facet>
                                            <h:outputText value="#{fila1.horasHombre} "  />
                                        </rich:column>
                                        <rich:column>
                                             <f:facet name="header">
                                                <h:outputText value="Horas Maquina"  />
                                            </f:facet>
                                            <h:outputText value="#{fila1.horasMaquina} "  />
                                        </rich:column>
                                </rich:dataTable>
                            </rich:column>
                        </rich:dataTable>
                        <rich:datascroller align="center" for="actividadesProducto" maxPages="20" id="scActividadesMaterial" ajaxSingle="true" />
                        </h:panelGroup>
                        <br/>
                            <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelActividadesProducto')" />
                        </div>
                    </rich:modalPanel>
                    
                    
                </div>

            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
            <a4j:include viewId="panelCancelarLote.jsp"/>
            <a4j:include viewId="panelTerminarProductoManualmente.jsp"/>
            <a4j:include viewId="panelAperturarLote.jsp"/>
            <a4j:include viewId="panelEnviosRealizados.jsp"/>
            <a4j:include viewId="panelModificarEnvioAcond.jsp"/>
            <a4j:include viewId="panelAnularEnvioAcond.jsp"/>
            <a4j:include viewId="panelImpresionOm.jsp"/>
            <a4j:include viewId="panelIngresoAcondicionamiento.jsp" id="panelIngresoAcondicionamiento"/>
            
            
            <rich:modalPanel id="panelCambioFechaPesaje"
                             minHeight="200"  minWidth="500"
                             height="200" width="500" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Cambio de Fecha de Pesaje" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form5">
                        <h:panelGroup id="contenidoCambioFechaPesaje">
                            <h:panelGrid columns="3">

                            <h:outputText styleClass="outputTextBold"   value="Fecha Pesaje"  />
                            <h:outputText styleClass="outputTextBold"   value="::"  />
                            <rich:calendar value="#{ManagedProgramaProduccion.fechaEtiquetasPesaje}" datePattern="dd/MM/yyyy" id="fechaPesaje"
                                           styleClass="inputText"/>
                            </h:panelGrid>
                            
                        </h:panelGroup>
                       <h:panelGrid columns="3" id="buttonEnvio">
                           <input type="button" value="Ver Etiquetas" class="btn" onclick="openPopup('reporteEtiquetas.jsp?fecha='+document.getElementById('form5:fechaPesajeInputDate').value);javascript:Richfaces.hideModalPanel('panelCambioFechaPesaje');" />
                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelCambioFechaPesaje')" />
                        </h:panelGrid>
                        <div style="display:none" id="progress">
                            <img src="../img/load.gif"/>
                        </div>
                        </div>
                        </a4j:form>
                    </rich:modalPanel>

                    <rich:modalPanel id="panelesCantidadesBolsas" minHeight="420"  minWidth="400"
                                     height="420" width="400"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto"  >
                        <f:facet name="header">
                            <h:outputText value="Cantidades"/>
                        </f:facet>
                        <a4j:form>
                            <center>
                        <h:panelGroup id="contenidoCantidadesBolsas" >
                                <rich:dataTable value="#{ManagedProgramaProduccion.ingresosAcond.ingresosDetalleAcondList.get(0).listadoCantidadPeso}" var="datalotes"
                                            id="listadolotes"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"                                        
                                            align="center">
                                <f:facet name="header">
                                    <rich:columnGroup>
                                        <rich:column>
                                            <h:outputText value=""  />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Nombre" styleClass="outputText2" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Cantidad" styleClass="outputText2" />
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Peso" styleClass="outputText2" />
                                        </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                                <rich:column styleClass="">
                                    <h:outputText value="#{datalotes.codigo}"  styleClass="outputText2"/>
                                </rich:column>
                                <rich:column styleClass="">
                                    <h:outputText value="#{datalotes.nombreEnvase}"  styleClass="outputText2"/>
                                </rich:column>

                                <rich:column styleClass="">
                                    <h:inputText value="#{datalotes.cantidad}" size="5" onkeypress="valNum()" styleClass="inputText" />
                                </rich:column>
                                <rich:column styleClass="">
                                    <h:inputText value="#{datalotes.peso}" size="5" styleClass="inputText" onkeypress="valNum()">
                                        <f:convertNumber pattern="###0.00" locale="en"/>
                                    </h:inputText>
                                </rich:column>
                            </rich:dataTable>
                            <br>
                        
                                <a4j:commandButton styleClass="btn" value="Registrar" onclick="javascript:Richfaces.hideModalPanel('panelesCantidadesBolsas');"  />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelesCantidadesBolsas')" class="btn" />
                        </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                <%--h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="Nº Ingreso :" styleClass="outputTextTitulo"  />
                            <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.nroIngresoAcond}"  id="nroIngresoAcond"  /--%>

                <rich:modalPanel id="panelComponentesProd" minHeight="420"  minWidth="500"
                                     height="420" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto"  >
                        <f:facet name="header">
                            <h:outputText value="Componentes"/>
                        </f:facet>
                        
                        <a4j:form>
                        <h:panelGrid columns="2">
                            <h:inputText value="#{ManagedProgramaProduccion.componentesProdBuscar.nombreProdSemiterminado}" styleClass="inputText"  size="60"  onkeypress="valMAY();" />
                            <a4j:commandButton  action="#{ManagedProgramaProduccion.buscarComponenteProdFormulaMaestra_action}"  reRender="contenidoComponentesProd" value="Buscar" styleClass="btn" />
                        </h:panelGrid>
                        
                        <h:panelGroup id="contenidoComponentesProd">
                            <rich:dataTable value="#{ManagedProgramaProduccion.componentesProdFormulaMaestraList}" var="data"
                                        id="listadoComponentesProd"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"
                                        align="center" width="100%" binding="#{ManagedProgramaProduccion.componentesProdFormulaMaestraDataTable}">
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Nombre" styleClass="outputText2" />
                                </f:facet>
                                <a4j:commandLink onclick="javascript:Richfaces.hideModalPanel('panelComponentesProd')" action="#{ManagedProgramaProduccion.seleccionarComponenteProdFormulaMaestra_action}" reRender="detalle">
                                    <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  styleClass="outputText2"/>
                                </a4j:commandLink>
                            </h:column>
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Cantidad Lote" styleClass="outputText2" />
                                </f:facet>                                
                                <h:outputText value="#{data.formulaMaestra.cantidadLote}"  styleClass="outputText2"/>
                            </h:column>
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Area" styleClass="outputText2" />
                                </f:facet>
                                <h:outputText value="#{data.componentesProd.areasEmpresa.nombreAreaEmpresa}"  styleClass="outputText2"/>
                            </h:column>                            
                        </rich:dataTable>
                        <div align="center">                        
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelComponentesProd')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                
                <rich:modalPanel id="panelRegistroDevoluciones"
                                     minHeight="330"  minWidth="900"
                                     height="330" width="900" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Devolucion de Materiales de Empaque Primario" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoRegistroDevoluciones">

                            <h:panelGrid columns="5">

                            <h:outputText styleClass="outputTextTitulo"   value="Almacen:"  />
                            <h:selectOneMenu styleClass="inputText"  value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.almacenAcond.codAlmacenAcond}"  disabled="true"  >
                                <a4j:support event="onchange" action="#{ManagedProgramaProduccion.cambioAlmacen_action}" reRender="contenidoIngresoAcondicionamiento" />
                                <f:selectItems value="#{ManagedProgramaProduccion.almacenAcondicionamientoList}"  />
                            </h:selectOneMenu>

                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="Nº Ingreso :" styleClass="outputTextTitulo"  />
                            <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.nroIngresoAcond}"  id="nroIngresoAcond"  />


                            <h:outputText value="Estado:" styleClass="outputTextTitulo"  />
                            <h:outputText value="A CONFIRMAR"  styleClass="tituloCampo"/>
                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="Tipo de Ingreso:" styleClass="outputTextTitulo" />
                            <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.tipoIngresoAcond.nombreTipoIngresoAcond}"  />

                            <h:outputText value="Observaciones:" styleClass="outputTextTitulo"  />
                            <h:inputTextarea styleClass="outputTextTitulo" rows="2" cols="50" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.obsIngresoAcond}"  disabled="true" />

                            </h:panelGrid>
                             <rich:dataTable value="#{ManagedProgramaProduccion.ingresosAlmacenDetalleAcondList}"
                                         var="data" id="detalleList"
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         >

                                        <f:facet name="header">
                                            <rich:columnGroup>
                                                <rich:column>
                                                    <h:outputText value="Descripción" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Lote"  styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Fecha Acond." styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Vida Util" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Fecha Vencimiento" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Cant. de Ingreso" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Peso [Kg.]" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Cant. Referencial" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Cant. de Envase" styleClass="tituloCampo" />
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="Tipo de Envase" styleClass="tituloCampo" />
                                                </rich:column>

                                            </rich:columnGroup>
                                        </f:facet>

                                        <h:column>
                                            <h:outputText   value="#{data.componentesProd.nombreProdSemiterminado}"  styleClass="outputTextNormal"/>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.codLoteProduccion}" styleClass="outputTextNormal"/>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.fechaPesaje}" styleClass="outputTextNormal" >
                                                <f:convertDateTime  pattern="dd/MM/yyyy" />
                                            </h:outputText>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.componentesProd.vidaUtil}" styleClass="outputTextNormal"/>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.fechaVencimiento}"  styleClass="outputTextNormal">
                                                <f:convertDateTime pattern="dd/MM/yyyy"  />
                                            </h:outputText>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.cantIngresoProduccion}"  styleClass="outputTextNormal"/>
                                       </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.pesoProduccion}"  styleClass="outputTextNormal"/>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.cantidadAproximado}" styleClass="outputTextNormal" id="cantAproximado" />
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.cantidadEnvase}" styleClass="outputTextNormal"/>

                                        </h:column>

                                        <h:column>
                                            <h:selectOneMenu value="#{data.tiposEnvase.codTipoEnvase}" styleClass="inputText" disabled="true" >
                                                <f:selectItems  value="#{data.tiposEnvases}" />
                                            </h:selectOneMenu>
                                        </h:column>


                        </rich:dataTable>
                        <div align="center"  style="width:99%;height:100px; overflow:auto;text-align:center">

                        <rich:dataTable value="#{ManagedProgramaProduccion.devolucionesMaterialDetalleList}"
                                         var="data" id="devolucionesMaterialesList"
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         >
                                         <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value=""/>
                                             </f:facet>
                                             <h:selectBooleanCheckbox value="#{data.checked}" />
                                        </h:column>
                                        <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Material" styleClass="outputTextNormal"/>
                                             </f:facet>
                                            <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputTextNormal"/>
                                        </h:column>
                                        <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Cantidad segun formula maestra"/>
                                             </f:facet>
                                             <h:outputText value="#{data.programaProduccionDevolucionMaterial.programaProduccion.formulaMaestra.cantidadLote}"   styleClass="outputTextNormal"  />
                                        </h:column>
                                         <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Cantidad Buenos A Devolver"/>
                                             </f:facet>
                                            <h:inputText value="#{data.cantidadBuenos}"   styleClass="inputText" size="10" />
                                        </h:column>
                                         <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Cantidad Malos A Devolver"/>
                                             </f:facet>
                                            <h:inputText value="#{data.cantidadMalos}"   styleClass="inputText" size="10" />
                                        </h:column>
                                        <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Unidad Medida"/>
                                             </f:facet>
                                            <h:outputText value="#{data.materiales.unidadesMedida.abreviatura}" styleClass="outputTextNormal"/>
                                        </h:column>
                                         <h:column>
                                             <f:facet name="header">
                                                 <h:outputText value="Observación"/>
                                             </f:facet>
                                            <h:inputText value="#{data.observacion}"   styleClass="inputText" size="10" />
                                        </h:column>
                                        </rich:dataTable>
                                       </div>

                        </h:panelGroup>
                        <br/>
                        <h:panelGrid columns="3">

                        <a4j:commandButton  value="GUARDAR" styleClass="btn" action="#{ManagedProgramaProduccion.registrarDevolucionesProgramaProduccion}" onclick="if(validarSeleccion('form3:devolucionesMaterialesList')==false){return false;}" oncomplete="javascript:Richfaces.hideModalPanel('panelRegistroDevoluciones')"/>
                        <input type="button" value="CANCELAR" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelRegistroDevoluciones')" />
                        </h:panelGrid>
                        </div>
                        </a4j:form>
                    </rich:modalPanel>
                    
                    <rich:modalPanel id="panelImpresionEtiquetas" minHeight="180"  minWidth="450"
                                     height="180" width="450"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registro de Cantidad por Caja"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                            <h:panelGroup id="contenidoImpresionEtiquetas">
                                   <h:panelGrid columns="2">
                                       <h:outputText value="Etiquetas:" styleClass="outputText1" />
                                       <h:selectOneMenu id="reporteEtiquetas">
                                           <f:selectItem itemLabel="Lote" itemValue="1" />
                                           <f:selectItem itemLabel="Mix" itemValue="2" />
                                       </h:selectOneMenu>
                                   </h:panelGrid>
                                        <div align="center">
                                            <a4j:commandButton styleClass="btn" value="Aceptar"  action="#{ManagedProgramaProduccion.verReporteEtiquetas}"
                                            oncomplete="openPopup('reporteEtiquetasAcond.jsf')"/>
                                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarCantidadPorCaja')" class="btn" />
                                        </div>
                            </h:panelGroup>
                        </a4j:form>
                    </rich:modalPanel>

                    

                        
    </html>
    
</f:view>

