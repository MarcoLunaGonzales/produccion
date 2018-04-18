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
                function validarRegistro()
                {
                    var tamanoLimite=parseFloat(document.getElementById("form1:tamLoteOficial").innerHTML);
                    var suma=0;
                    var tabla=document.getElementById("form1:dataProgramaProduccion");
                    for(var i=1;i<tabla.rows.length;i++)
                        {
                            suma+=parseFloat(tabla.rows[i].cells[2].getElementsByTagName('input')[0].value);
                            if(tabla.rows[i].cells[3].getElementsByTagName('select').length>0&&tabla.rows[i].cells[3].getElementsByTagName('select')[0].value==0)
                            {
                               alert('Debe seleccionar el tipo de programa produccion');
                               return false;
                            }
                           if(tabla.rows[i].cells[6].getElementsByTagName('select')[0].value==0)
                            {
                               alert('Debe seleccionar el lugar acond');
                               return false;
                            }

                        }
                    /*if(tamanoLimite!=suma)
                    {
                        alert('Debe registrar una cantidad de productos igual a la cantidad total del lote');
                        return false;
                    }*/

                        return true;
                }
                function buscarTexto()
                {
                    var tablaBuscar = document.getElementById('formForm:detalle');
                    var textoBuscar= document.getElementById('productoBuscar').value.toLowerCase();
                    var encontrado=false;
                    for (var i = 1; i < tablaBuscar.rows.length; i++)
                    {
                        encontrado=false;
                        if (textoBuscar.length == 0 || (tablaBuscar.rows[i].cells[0].innerHTML.toLowerCase().indexOf(textoBuscar) > -1))
                        {
                            encontrado= true;
                        }

                        if(encontrado)
                        {
                            tablaBuscar.rows[i].style.display = '';
                        } else {
                            tablaBuscar.rows[i].style.display = 'none';
                        }
                    }
                }
</script>

        </head>
            <body  >


            <a4j:form id="form1"   >
                <div align="center" >

                    <h:outputText value="#{ManagedProgramaProduccionSimulacion.cargarContenidoEditarProgramaProduccionSimulacion}" />

                     <h:panelGroup id="contenidoAgregarLote" >
                         <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                <h:outputText value="Datos producto"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Producto"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccionSimulacion.programaProduccionCabeceraEditar.formulaMaestra.componentesProd.nombreProdSemiterminado}"  styleClass="outputText2"/>
                                <h:outputText styleClass="outputTextBold" value="Cantidad Lote"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccionSimulacion.programaProduccionCabeceraEditar.formulaMaestra.cantidadLote}" styleClass="outputText2" id="tamLoteOficial"/>
                            </h:panelGrid>
                            <%--a4j:commandLink reRender="contenidoAgregarFormulaCabecera" oncomplete="Richfaces.showModalPanel('panelAgregarFormulaCabecera')">
                                <h:graphicImage url="../img/buscar.png" />
                                <h:outputText value="Cambiar Producto"/>
                            </a4j:commandLink--%>
                        </rich:panel>
                        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionEditarList}" var="data"
                                    id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    style="margin-top:1em;" rowKeyVar="var"
                                    binding="#{ManagedProgramaProduccionSimulacion.programaProduccionEditarDataTable}">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Lote"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Programa Producción"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Presentación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Lugar Acond."  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{var!=0}"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink rendered="#{var != 0}" action="#{ManagedProgramaProduccionSimulacion.modificarProductoProgramaProduccionEditar_action}"
                                oncomplete="Richfaces.showModalPanel('panelModificarProducto');" reRender="contenidoModificarProducto">
                                    <h:graphicImage url="../img/edit.jpg" style="vertical-align:middle"/>
                                    <h:outputText styleClass="outputText2" value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"/>
                            </a4j:commandLink>
                            <h:outputText rendered="#{var eq 0}" value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.cantidadLote}" styleClass="inputText"  />
                        </rich:column>
                        <rich:column>
                            <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd eq ''}">
                                <f:selectItems value="#{ManagedProgramaProduccionSimulacion.tiposProgramaProdList}" />
                                <a4j:support event="onchange"  action="#{ManagedProgramaProduccionSimulacion.cargarPresentacionesProductoEditarSelect}" reRender="dataProgramaProduccion"/>
                            </h:selectOneMenu>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd != ''}"/>

                        </rich:column>
                        <h:column>
                            <h:selectOneMenu value="#{data.presentacionesProducto.codPresentacion}" styleClass="inputText">
                                <f:selectItems value="#{data.presentacionesProductoList}" />
                            </h:selectOneMenu>
                        </h:column>
                        <rich:column>
                            <h:inputText value="#{data.observacion}" styleClass="inputText" style="width:25em" />
                        </rich:column>
                        <rich:column>
                            <h:selectOneMenu value="#{data.lugaresAcond.codLugarAcond}" styleClass="inputText" >
                                <f:selectItems value="#{ManagedProgramaProduccionSimulacion.lugaresAcondList}" />
                            </h:selectOneMenu>
                        </rich:column>
                    </rich:dataTable>
                        <center>
                        <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.masProgramaProduccionEditar_action}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.menosProgramaProduccionEditar_action}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                        </center>

                     </h:panelGroup>

                    <br>
                        <a4j:commandButton value="Guardar" action="#{ManagedProgramaProduccionSimulacion.guardarEdicionProgramaProduccion_action}" onclick="if(!validarRegistro()){return false;}"
                        oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje eq '1'}){alert('Se registraron los lotes');window.location.href='navegadorProgramaProduccionSimulacion.jsf?codProgramaProd=#{ManagedProgramaProduccionSimulacion.programaProduccionCabeceraEditar.codProgramaProduccion}&data='+(new Date()).getTime().toString();}else{alert('#{ManagedProgramaProduccion.mensaje}');}" styleClass="btn"/>
                        <a4j:commandButton value="Limpiar" styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.limpiar_action}" reRender="dataProgramaProduccion" />
                        <a4j:commandButton styleClass="btn" oncomplete="window.location.href='navegadorProgramaProduccionSimulacion.jsf?codProgramaProd=#{ManagedProgramaProduccionSimulacion.programaProduccionCabeceraEditar.codProgramaProduccion}&cancel='+(new Date()).getTime().toString();" value="Cancelar" />
            </a4j:form>
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
         <rich:modalPanel id="panelFormulaMaestraDetalleMP" minHeight="250"  minWidth="600"
                                     height="250" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" immediate="true" >
                        <f:facet name="header">
                            <h:outputText value="Detalle Materia Prima"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoFormulaMaestraDetalleMP">
                            <div align="center">
                            <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraMPList}"
                                    var="data" id="dataFormulaMP"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"  >
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.materiales.checked}"  />
                        </h:column--%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText  value="#{data.materiales.nombreMaterial}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  >
                                <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00" />
                            </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>

                    </rich:dataTable>
                    </h:panelGroup>
                    <br/>
                                <a4j:commandButton styleClass="btn" value="Aceptar" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraDetalleMP');"

                                                    />
                                                    </div>

                        </a4j:form>
            </rich:modalPanel>

             <rich:modalPanel id="panelFormulaMaestraDetalleMR" minHeight="250"  minWidth="600"
                                     height="250" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Detalle Material Reactivo"/>
                        </f:facet>
                        <a4j:form id="form3">
                            <h:panelGroup id="contenidoFormulaMaestraDetalleMR">
                                <div align="center">
                                        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraMRList}"
                                                var="data" id="dataFormulaMR"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  >
                                            <%--h:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />

                                                </f:facet>
                                                <h:selectBooleanCheckbox value="#{data.materiales.checked}"  />
                                            </h:column--%>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Materia Prima"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.materiales.nombreMaterial}" />
                                            </h:column>

                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad"  />
                                                </f:facet>
                                                <h:outputText value="#{data.cantidad}"  >
                                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00" />
                                                </h:outputText>
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Unidad Medida"  />
                                                </f:facet>
                                                <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                                            </h:column>

                                        </rich:dataTable>
                                        <br/>
                                    <a4j:commandButton styleClass="btn" value="Aceptar"
                                    onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraDetalleMR');"
                                    />
                                    </div>
                            </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelFormulaMaestraDetalleEP" minHeight="250"  minWidth="600"
                                     height="250" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto"  >
                        <f:facet name="header">
                            <h:outputText value="Detalle Empaque Primario"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <h:panelGroup id="contenidoFormulaMaestraDetalleEP">
                                <div align="center">
                                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraEPList}"
                                                var="data" id="dataFormulaEP"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  >
                                            <%--h:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />

                                                </f:facet>
                                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                                            </h:column--%>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Materia Prima"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.materiales.nombreMaterial}" />
                                            </h:column>

                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad"  />
                                                </f:facet>
                                                <h:outputText value="#{data.cantidad}"  >
                                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00" />
                                                </h:outputText>
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Unidad Medida"  />
                                                </f:facet>
                                                <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                                            </h:column>

                                        </rich:dataTable>
                                        <br/>
                                    <a4j:commandButton styleClass="btn" value="Aceptar"
                                    onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraDetalleEP');"
                                    />
                                    </div>
                            </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelFormulaMaestraDetalleES" minHeight="250"  minWidth="600"
                                     height="250" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Detalle Empaque Primario"/>
                        </f:facet>
                        <a4j:form id="form5">
                            <h:panelGroup id="contenidoFormulaMaestraDetalleES">
                                <div align="center">
                                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraESList}"
                                                var="data" id="dataFormulaEP"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                headerClass="headerClassACliente"  >
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />

                                                </f:facet>
                                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Materia Prima"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.materiales.nombreMaterial}" />
                                            </h:column>

                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad"  />
                                                </f:facet>
                                                <h:outputText value="#{data.cantidad}"  >
                                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00" />
                                                </h:outputText>
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Unidad Medida"  />
                                                </f:facet>
                                                <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                                            </h:column>

                                        </rich:dataTable>
                                        <br/>
                                    <a4j:commandButton styleClass="btn" value="Aceptar"
                                    onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraDetalleES');"
                                    />
                                    </div>
                            </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelAgregarFormulaCabecera"
                             minHeight="340"  minWidth="700"
                             height="340" width="700" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
                <f:facet name="header">
                    <h:outputText value="<center>Formulas Maestras</center>" escape="false" />
                </f:facet>
                <a4j:form id="formForm">
                    <center>
                    <h:panelGroup id="contenidoAgregarFormulaCabecera">
                        <span class="outputTextBold">Producto:</span><input id="productoBuscar" class="inputText" onkeyup="buscarTexto();">
                        <table><tr><td>
                        <div style='height:240px;overflow:auto;width:100%'>
                        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraAgregarList}"
                                     var="data" id="detalle"
                                     headerClass="headerClassACliente"
                                     onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                     onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                              <f:facet name="header">
                                  <rich:columnGroup>
                                      <rich:column rowspan="2">
                                          <h:outputText value="Producto Semiterminado"/>
                                      </rich:column>
                                      <rich:column rowspan="2">
                                          <h:outputText value="Cantidad Lote"/>
                                      </rich:column>

                                  </rich:columnGroup>
                              </f:facet>

                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.seleccionarFormulaMaestraPrograma_action}"
                                      oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarFormulaCabecera');"
                                      reRender="contenidoAgregarLote">
                                          <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                          <f:param name="cantidadLote" value="#{data.cantidadLote}"/>
                                          <f:param name="nombreCompProd" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                          <f:param name="codFormula" value="#{data.codFormulaMaestra}"/>

                                          <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                      </a4j:commandLink>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.cantidadLote}"/>
                                  </rich:column>

                        </rich:dataTable>
                        </div>
                        </td></tr></table>
                    </h:panelGroup>
                    <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarFormulaCabecera');" styleClass="btn"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelModificarProducto"
                             minHeight="340"  minWidth="700"
                             height="340" width="700" zindex="200"
                             headerClass="headerClassACliente"
                             resizeable="false">
                <f:facet name="header">
                    <h:outputText value="<center>Productos para división de lotes</center>" escape="false" />
                </f:facet>
                <a4j:form id="formModificar">
                    <center>
                    <h:panelGroup id="contenidoModificarProducto">
                        <table><tr><td>
                        <div style='height:240px;overflow:auto;width:100%'>
                        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.productosDivisionLotesList}"
                                     var="data" id="detalle"
                                     headerClass="headerClassACliente"
                                     onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                     onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                              <f:facet name="header">
                                  <rich:columnGroup>
                                      <rich:column >
                                          <h:outputText value="Producto Semiterminado"/>
                                      </rich:column>
                                      <rich:column >
                                          <h:outputText value="Tipo Programa Producción"/>
                                      </rich:column>
                                      <rich:column >
                                          <h:outputText value="Cantidad Lote"/>
                                      </rich:column>

                                  </rich:columnGroup>
                              </f:facet>

                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.modificarProductoDivisionLotes_action}"
                                      oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');"
                                      reRender="contenidoAgregarLote">
                                          <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                          <f:param name="codTipoProgramaProd" value="#{data.tiposProgramaProduccion.codTipoProgramaProd}"/>
                                          <f:param name="nombreCompProd" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                          <f:param name="nombreTipoPrograma" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                          <f:param name="codFormula" value="#{data.formulaMaestra.codFormulaMaestra}"/>
                                          <f:param name="cantidadLote" value="#{data.formulaMaestra.cantidadLote}"/>
                                          <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                      </a4j:commandLink>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                  </rich:column>
                                  <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                      <h:outputText value="#{data.formulaMaestra.cantidadLote}"/>
                                  </rich:column>



                        </rich:dataTable>
                        </div>
                        </td></tr></table>
                    </h:panelGroup>
                    <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');" styleClass="btn"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            </div>

        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>

</f:view>

