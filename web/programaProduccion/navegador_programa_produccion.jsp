
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
                function iniciarEnvioAcond()
                {
                    document.getElementById("form2:buttonEnvio").style.display='none';
                    document.getElementById("progress").style.display='block';
                }
                function terminarEnvioAcond()
                {
                    document.getElementById("form2:buttonEnvio").style.display='block';
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
                    <h:outputText value="#{ManagedProgramaProduccion.cargarContenidoProgramaProduccion}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    <br><br>
                        <br>Buscar
                        <a4j:commandLink action="#{ManagedProgramaProduccion.buscarLoteProduccion_action}" oncomplete="Richfaces.showModalPanel('panelBuscarLoteProduccion')" >
                                <h:graphicImage url="../img/buscar.png" />
                        </a4j:commandLink>
                    
                    <br> <br>
                    <h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo();"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" />
                    <br> <br>
                    <h:panelGroup id="contenidoProgramaProduccion">
                        
                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccion.programaProduccionDataTable}">
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadoProgramaProduccion.codEstadoProgramaProd!='6'}"  />
                        </rich:column >

                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
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
                                <h:outputText value="Fecha Vencimiento"  >
                                    
                                </h:outputText>
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimiento}"  >
                                <f:convertDateTime  pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Fecha Final"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}"  />
                        </rich:column >
                        <rich:column  styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}"  >
                            <f:facet name="header">
                                <h:outputText value="Version Formula Maestra"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestraVersion.nroVersion}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}"  >
                            <f:facet name="header">
                                <h:outputText value="Version Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProdVersion.nroVersion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}"  >
                            <f:facet name="header">
                                <h:outputText value="Categoría"  />
                            </f:facet>
                            <h:outputText value="#{data.categoriasCompProd.nombreCategoriaCompProd}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header" >
                                <h:outputText value="Estado Materia Prima"  />
                            </f:facet>
                            <h:outputText value="#{data.materialTransito}" id="n" />
                        </rich:column>
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
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action}"
                            rendered="#{data.formulaMaestra.componentesProd.forma.codForma != 2}" >
                                <f:param name="codAreaEmpresa" value="96" />
                                <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
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
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Etiquetas"  />
                            </f:facet>

                            <a4j:commandLink action="#{ManagedProgramaProduccion.verReporteEtiquetas_action}" oncomplete="openPopup('reporteEtiquetas.jsp')">
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column  style="#{data.conDesviacion>0?'background-color:#E2A9F3':''}">
                            <f:facet name="header">
                                <h:outputText value="Etiquetas Desviacion"  />
                            </f:facet>

                            <a4j:commandLink action="#{ManagedProgramaProduccion.verReporteEtiquetas_action}" oncomplete="openPopup('reporteEtiquetasDesv.jsp')">
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    
                    <br>
                    <rich:panel headerClass="headerClassACliente" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1738'|| ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '826' || ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1788'}">
                            <h:commandButton value="Agregar" action="#{ManagedProgramaProduccion.agregarProgramaProduccion_action}"  styleClass="btn"  /> <%--  action="#{ManagedProgramaProduccion.actionagregar}" oncomplete="location='navegador_programa_produccion_lotes.jsf'" --%>
                            <h:commandButton value="Editar Lote"    styleClass="btn"  action="#{ManagedProgramaProduccion.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                            <h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarProgProd}" onclick="if(confirm('Esta seguro de eliminar el registro?')==false){return false}"/><%-- else{return eliminar('form1:dataFormula');} --%>
                            <h:commandButton value="Reservar"    styleClass="btn"  action="#{ManagedProgramaProduccion.guardarReserva}" onclick="return reserva('form1:dataFormula');"/>
                            <h:commandButton value="Eliminar Reserva"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarReserva}" onclick="return eliminarReserva('form1:dataFormula');"/>
                            <a4j:commandButton value="Terminar Producto" styleClass="btn"
                                   oncomplete="if(#{ManagedProgramaProduccion.mensajes=='faltaFechaPesaje'}){alert('El producto no tiene registrado fecha de pesaje');}
                                               if(#{ManagedProgramaProduccion.mensajes=='faltanActividades'}){alert('faltan registrar horas en actividades el producto');}
                                               if(#{ManagedProgramaProduccion.mensajes=='faltanTiempos'}){alert('faltan registrar horas en actividades el producto');
                                               openPopup('reporteLotes.jsf?codProgramaProdPeriodo=#{ManagedProgramaProduccion.programaProduccionbean.codProgramaProduccion}');}else{javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');}"
                                               action="#{ManagedProgramaProduccion.terminarProducto_action}"
                                               reRender="contenidoActividadesProducto,contenidoIngresoAcondicionamiento"/><%-- Richfaces.showModalPanel('panelActividadesProducto',{width:100, top:100}); javascript:Richfaces.showModalPanel('panelActividadesProducto',{width:100, top:100});--%>
                    </rich:panel>
                    <h:commandButton value="Registrar Actividades Indirectas" action="#{ManagedProgramaProduccion.agregarSeguimientoIndirectas_action}"  styleClass="btn"  />
                    <a4j:commandButton value="Enviar Materiales a Reanalisis" action="#{ManagedProgramaProduccion.verReporteMaterialesVencidos_action}" oncomplete="Richfaces.showModalPanel('panelMaterialesVencidos')" reRender="contenidoMaterialesVencidosReanalisis"   styleClass="btn"     />
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
                        <%--
                        <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                        onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                        ajaxSingle="false" status="statusPeticion" />
                        --%>
                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelActividadesProducto')" />
                        </div>
                    </rich:modalPanel>
                    
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
            <rich:modalPanel id="panelIngresoAcondicionamiento"
                                     minHeight="300"  minWidth="900"
                                     height="300" width="900" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Ingreso Acondicionamiento" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoIngresoAcondicionamiento">

                            <h:panelGrid columns="5">

                            <h:outputText styleClass="outputTextTitulo"   value="Almacen:"  />
                            <h:selectOneMenu styleClass="inputText"  value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.almacen.codAlmacenAcond}"   id="codAlmacenAcondicionamiento" >
                                <a4j:support event="onchange" action="#{ManagedProgramaProduccion.cambioAlmacen_action}" reRender="contenidoIngresoAcondicionamiento" />
                                <f:selectItems value="#{ManagedProgramaProduccion.almacenAcondicionamientoList}"  />
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputTextTitulo"   value="Entrega Total:"  />
                            <h:selectOneRadio value="#{ManagedProgramaProduccion.entregaTotal}">
                                <f:selectItem itemValue='false' itemLabel="SI"/>
                                <f:selectItem itemValue='true' itemLabel="NO"/>
                            </h:selectOneRadio>
                            

                            <h:outputText value="Estado:" styleClass="outputTextTitulo"  />
                            <h:outputText value="A CONFIRMAR"  styleClass="tituloCampo"/>
                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="Tipo de Ingreso:" styleClass="outputTextTitulo" />
                            <h:outputText styleClass="tituloCampo" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.tipoIngresoAcond.nombreTipoIngresoAcond}"  />

                            <%--
                            <h:outputText styleClass="outputTextTitulo" value="Nº Documento:"  />
                            <h:inputText styleClass="inputText"  value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.nroDocIngresoAcond}" size="10" id="nroDoc"  />
                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            <h:outputText value="         " styleClass="outputTextTitulo"  />
                            --%>


                            <h:outputText value="Observaciones:" styleClass="outputTextTitulo" />
                            <h:inputTextarea styleClass="inputText" rows="2" cols="50" value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.obsIngresoAcond}"   />

                            </h:panelGrid>
                            
                            <rich:dataTable value="#{ManagedProgramaProduccion.ingresosAlmacenDetalleAcondList}"
                                         var="data" id="detalle"                                         
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         binding="#{ManagedProgramaProduccion.ingresosAlmacenDetalleAcondDataTable}">

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
                                                <rich:column>
                                                    <h:outputText value="Lotes" styleClass="tituloCampo" />
                                                </rich:column>
                                            </rich:columnGroup>
                                        </f:facet>

                                        <h:column>
                                            <h:outputText   value="#{data.componentesProd.nombreProdSemiterminado}"  />                                            
                                        </h:column>
                                        <h:column>
                                            <h:inputText value="#{data.codLoteProduccion}" onkeypress="valMAY();"   styleClass="inputText" size="10" id="codLote" readonly="true" />
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.fechaPesaje}" >
                                                <f:convertDateTime  pattern="dd/MM/yyyy" />
                                            </h:outputText>
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.componentesProd.vidaUtil}" />
                                        </h:column>
                                        <h:column>
                                            <h:inputText value="#{data.fechaVencimiento}" style="text-align:center;" styleClass="inputText" size="15" id="fechaVencimiento" onblur="valFecha(this);" >
                                                <f:convertDateTime pattern="dd/MM/yyyy"  />
                                            </h:inputText>
                                        </h:column>
                                        <h:column>
                                            <h:inputText value="#{data.cantIngresoProduccion}" onkeypress="valNum()"    styleClass="inputText" size="10" id="cantIngresoProd" /> <%-- onkeyup="if(this.value>#{ManagedProgramaProduccion.programaProduccionbean.formulaMaestra.cantidadLote}){alert('no debe sobrepasar la cantidad de lote');this.value=#{ManagedProgramaProduccion.programaProduccionbean.formulaMaestra.cantidadLote}}" --%>
                                        </h:column>
                                        <h:column>
                                            <h:inputText value="#{data.pesoProduccion}" onkeypress="valNum();"  styleClass="inputText"  size="10"  id="pesoProd" />
                                        </h:column>
                                        <h:column>
                                            <h:outputText value="#{data.cantidadAproximado}" styleClass="outputTextNormal" id="cantAproximado" />
                                        </h:column>
                                        <h:column>
                                            <h:selectOneMenu value="#{data.cantidadEnvase}" styleClass="inputText" id="cantEnvase">
                                                <f:selectItem  itemValue="0" itemLabel="0"  />
                                                <f:selectItem  itemValue="1" itemLabel="1"  />
                                                <f:selectItem  itemValue="2" itemLabel="2"  />
                                                <f:selectItem  itemValue="3" itemLabel="3"  />
                                                <f:selectItem  itemValue="4" itemLabel="4"  />
                                                <f:selectItem  itemValue="5" itemLabel="5"  />
                                                <f:selectItem  itemValue="6" itemLabel="6"  />
                                                <f:selectItem  itemValue="7" itemLabel="7"  />
                                                <f:selectItem  itemValue="8" itemLabel="8"  />
                                                <f:selectItem  itemValue="9" itemLabel="9"  />
                                                <f:selectItem  itemValue="10" itemLabel="10"  />

                                                <f:selectItem  itemValue="11" itemLabel="11"  />
                                                <f:selectItem  itemValue="12" itemLabel="12"  />
                                                <f:selectItem  itemValue="13" itemLabel="13"  />
                                                <f:selectItem  itemValue="14" itemLabel="14"  />
                                                <f:selectItem  itemValue="15" itemLabel="15"  />
                                                <f:selectItem  itemValue="16" itemLabel="16"  />
                                                <f:selectItem  itemValue="17" itemLabel="17"  />
                                                <f:selectItem  itemValue="18" itemLabel="18"  />
                                                <f:selectItem  itemValue="19" itemLabel="19"  />
                                                <f:selectItem  itemValue="20" itemLabel="20"  />

                                                <f:selectItem  itemValue="21" itemLabel="21"  />
                                                <f:selectItem  itemValue="22" itemLabel="22"  />
                                                <f:selectItem  itemValue="23" itemLabel="23"  />
                                                <f:selectItem  itemValue="24" itemLabel="24"  />
                                                <f:selectItem  itemValue="25" itemLabel="25"  />
                                                <f:selectItem  itemValue="26" itemLabel="26"  />
                                                <f:selectItem  itemValue="27" itemLabel="27"  />
                                                <f:selectItem  itemValue="28" itemLabel="28"  />
                                                <f:selectItem  itemValue="29" itemLabel="29"  />
                                                <f:selectItem  itemValue="30" itemLabel="30"  />
                                                <f:selectItem  itemValue="31" itemLabel="31"  />
                                                <f:selectItem  itemValue="32" itemLabel="32"  />
                                                <f:selectItem  itemValue="33" itemLabel="33"  />
                                                <f:selectItem  itemValue="34" itemLabel="34"  />
                                                <f:selectItem  itemValue="35" itemLabel="35"  />
                                                <f:selectItem  itemValue="36" itemLabel="36"  />
                                                <f:selectItem  itemValue="37" itemLabel="37"  />
                                                <f:selectItem  itemValue="38" itemLabel="38"  />
                                                <f:selectItem  itemValue="39" itemLabel="39"  />
                                                <f:selectItem  itemValue="40" itemLabel="40"  />
                                                <f:selectItem  itemValue="41" itemLabel="41"  />
                                                <f:selectItem  itemValue="42" itemLabel="42"  />
                                                <f:selectItem  itemValue="43" itemLabel="43"  />
                                                <f:selectItem  itemValue="44" itemLabel="44"  />
                                                <f:selectItem  itemValue="45" itemLabel="45"  />
                                                <f:selectItem  itemValue="46" itemLabel="46"  />
                                                <f:selectItem  itemValue="47" itemLabel="47"  />
                                                <f:selectItem  itemValue="48" itemLabel="48"  />
                                                <f:selectItem  itemValue="49" itemLabel="49"  />
                                                <f:selectItem  itemValue="50" itemLabel="50"  />



                                            </h:selectOneMenu>
                                        </h:column>

                                        <h:column>
                                            <h:selectOneMenu value="#{data.tiposEnvase.codTipoEnvase}" styleClass="inputText" id="codTipoEnvase" >
                                                <f:selectItems  value="#{data.tiposEnvases}" />
                                            </h:selectOneMenu>
                                        </h:column>

                                        <h:column>
                                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelesCantidadesBolsas')" action="#{ManagedProgramaProduccion.cargarCantidadesLotes_action}" reRender="contenidoCantidadesBolsas,contenidoIngresoAcondicionamiento"  >
                                                <h:graphicImage url="../img/lotes.png" style="border:none;" alt="Lotes" />
                                            </a4j:commandLink>
                                        </h:column>

                        </rich:dataTable>
                        </h:panelGroup>
                        <br/>
                        <%--inicio ale unidades medida--%>
                        <a4j:jsFunction name="agregarDevolucion" action="#{ManagedProgramaProduccion.cargarRegistroDevolucionesAction}" oncomplete="javascript:Richfaces.showModalPanel('panelRegistroDevoluciones')" reRender="contenidoRegistroDevoluciones"/>
                        <%--final ale unidades medida--%>
                        <h:panelGrid columns="3" id="buttonEnvio">
                            <a4j:commandButton  value="Entrega Parcial" styleClass="btn" ondblclick="return false;" onclick="iniciarEnvioAcond();"  actionListener="#{ManagedProgramaProduccion.guardarIngresoParcialAcondicionamiento_action}" reRender="contenidoProgramaProduccion" ajaxSingle="false" status="statusPeticion"
                            oncomplete="if(#{ManagedProgramaProduccion.mensajes eq '1'}){alert('Termino de registrar correctamente con el numero de ingreso #{ManagedProgramaProduccion.ingresosAcondicionamiento.nroIngresoAcond}');javascript:Richfaces.hideModalPanel('panelIngresoAcondicionamiento');}else{alert('#{ManagedProgramaProduccion.mensajes}')}terminarEnvioAcond();" timeout="7200" /> <%-- oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){alert('#{ManagedProgramaProduccion.mensajes}');}" --%>
                        <%-- oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){alert('#{ManagedProgramaProduccion.mensajes}');if(#{ManagedProgramaProduccion.mensajeSolicitudAutomatica!=''}){alert('#{ManagedProgramaProduccion.mensajeSolicitudAutomatica}')}}terminarEnvioAcond();" --%>

                        <%--a4j:commandButton  value="Entrega Total" styleClass="btn"
                        onclick="if(confirm('Esta seguro de guardar esta informacion')==false){return false;}else{javascript:Richfaces.hideModalPanel('panelIngresoAcondicionamiento')}"
                        actionListener="#{ManagedProgramaProduccion.guardarIngresosAcondicionamiento_action}" reRender="contenidoProgramaProduccion" ajaxSingle="false" status="statusPeticion"
                        oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){alert('#{ManagedProgramaProduccion.mensajes}');}"/--%>
                        <a4j:commandButton  value="Entrega Total" styleClass="btn" ondblclick="return false;"
                        onclick="iniciarEnvioAcond();if(confirm('Esta seguro de guardar esta informacion')==false){terminarEnvioAcond();return false;}"
                        actionListener="#{ManagedProgramaProduccion.guardarIngresosAcondicionamiento_action}" reRender="contenidoProgramaProduccion" ajaxSingle="false" status="statusPeticion"
                        oncomplete="if(#{ManagedProgramaProduccion.mensajes eq '1'}){alert('Termino de registrar correctamente con el numero de ingreso #{ManagedProgramaProduccion.ingresosAcondicionamiento.nroIngresoAcond}');javascript:Richfaces.hideModalPanel('panelIngresoAcondicionamiento');}else{alert('#{ManagedProgramaProduccion.mensajes}');}terminarEnvioAcond();"  timeout="7200"/><%-- oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){alert('#{ManagedProgramaProduccion.mensajes}');}else{alert('Termino de registrar el ingreso correctamente');if(confirm('desea registrar devoluciones?')==true){agregarDevolucion();}}" --%>
                        <%-- oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){alert('#{ManagedProgramaProduccion.mensajes}');if(#{ManagedProgramaProduccion.mensajeSolicitudAutomatica!=''}){alert('#{ManagedProgramaProduccion.mensajeSolicitudAutomatica}')}}--%>


                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelIngresoAcondicionamiento')" />
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
                        <h:panelGroup id="contenidoCantidadesBolsas">
                        <rich:dataTable value="#{ManagedProgramaProduccion.cantidadesBolsasList}" var="datalotes"
                        id="listadolotes"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"                                        
                                        align="center"
                        >
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
                                <h:inputText value="#{datalotes.cantidad}" styleClass="inputText" />
                            </rich:column>
                            <rich:column styleClass="">
                                <h:inputText value="#{datalotes.peso}" styleClass="inputText"  />
                            </rich:column>
                        </rich:dataTable>                        
                        <div align="center">
                        <a4j:commandButton styleClass="btn" value="Registrar" onclick="javascript:Richfaces.hideModalPanel('panelesCantidadesBolsas');"  actionListener="#{ManagedProgramaProduccion.registrarDetalle_action}" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelesCantidadesBolsas')" class="btn" />
                        </div>
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
                
                <%--inicio ale devoluciones--%>
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
                            <h:selectOneMenu styleClass="inputText"  value="#{ManagedProgramaProduccion.ingresosAcondicionamiento.almacen.codAlmacenAcond}"  disabled="true"  >
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
                                <h:inputText value="#{ManagedProgramaProduccion.programaProduccionBuscar.codLoteProduccion}" styleClass="inputText2"  />
                                
                            </h:panelGrid>


                                 <a4j:commandButton value="Aceptar" action="#{ManagedProgramaProduccion.buscaLoteProduccion_action}" oncomplete = "location ='navegador_programa_produccion.jsf'" styleClass="btn"/>
                                 <input value="Cancelar" onclick="Richfaces.hideModalPanel('panelBuscarLoteProduccion')" class="btn" type="button" />


                                </div>
                        </h:panelGroup>
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


                    <rich:modalPanel id="panelMaterialesVencidos"  minHeight="400"  minWidth="800"
                                     height="400" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Materiales Vencidos por actualizar a reanalisis "/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoMaterialesVencidosReanalisis">
                            <div align="center">
                                <rich:dataTable  value="#{ManagedProgramaProduccion.materialesVencidosList}"
                                         width="100%"  var="fila"                                         
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         id="actividadesProducto"  align="center">
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Fecha Ingreso"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.fechaIngresoAlmacen} ">
                                        <f:convertDateTime pattern="dd/MM/yyyy" />
                                    </h:outputText>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="nro Ingreso"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.nroIngresoAlmacen} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Fecha Vencimiento"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.fechaVencimiento} ">
                                        <f:convertDateTime pattern="dd/MM/yyyy" />
                                    </h:outputText>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Nombre Material"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.materiales.nombreMaterial} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.cantidadRestante} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Estado Material"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.nombreEstadoMaterial} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Empaque"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.nombreEmpaque} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Lote Material Proveedor"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.loteMaterialProveedor} "/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Proveedor"/>
                                    </f:facet>
                                    <h:outputText value="#{fila.nombreProveedor} "/>
                                </rich:column>
                            </rich:dataTable>


                             </div>
                        </h:panelGroup>
                        <div align="center">
                        <a4j:commandButton value="Enviar Reanalisis" action="#{ManagedProgramaProduccion.actualizaMaterialesReanalisis_action}" oncomplete="alert('se hizo la actualizacion de estado a reanalisis');Richfaces.hideModalPanel('panelMaterialesVencidos')" styleClass="btn" />
                        </div>
                        </a4j:form>
                    </rich:modalPanel>
                    

                        <%--final ale devoluciones--%>

            
        </body>
    </html>
    
</f:view>

