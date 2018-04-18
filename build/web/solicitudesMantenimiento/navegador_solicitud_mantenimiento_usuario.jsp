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
            <script>
                function cogerId(obj){
                    alert(obj);


                }
                function getCodigo(codigoSolicitud){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
                    url='navegador_aprobar_solicitud_mantenimiento_usuario.jsf?codigo='+codigoSolicitud;
                    url='seguimiento_solicitud_mantenimiento_usuario.jsf?codigo='+codigoSolicitud;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

                }
                function getCodigo1(codComProd,codigo,codFormula,codLote){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    url='../barcode?number=1&location='+codComProd+"-"+codigo+"-"+codFormula+"-"+codLote;
                    //url='../codigo_barras.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                    alert(url);
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


            </script>
        </head>
        <body >


            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSolicitudMantenimiento.cargarSolicitudMantenimientoUsuario}"  />
                    <h3 align="center">Ordenes de Trabajo</h3>


                    <h:outputText styleClass="outputTextTitulo"  value="Estado::" />
                    <h:selectOneMenu value="#{ManagedSolicitudMantenimiento.solicitudMantenimientobean.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento}" styleClass="inputText"
                                     valueChangeListener="#{ManagedSolicitudMantenimiento.changeEventUsuario}">
                        <f:selectItems value="#{ManagedSolicitudMantenimiento.estadosSolicitudMantenimientoList}" />
                        <a4j:support event="onchange"  reRender="dataFormula"  />
                    </h:selectOneMenu>
                    <br> <br>
                    <h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo();"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" />
                    <br>
                    <h:panelGrid columns="13"   cellpadding="0"  cellspacing="2" >
                        <h:outputText value="Leyenda:"  styleClass="tituloCampo"  style="vertical-align:cente;text-align:center" />

                        <h:outputText value="Emitido"  styleClass="tituloCampo"   />
                        <h:outputText value=""    style="width:50px;border:1px solid #000000;background-color: #F6E3CE;" />

                        <h:outputText value="Revisado"  styleClass="tituloCampo"   />
                        <h:outputText value="" style="width:40px;border:1px solid #000000;background-color: #CEF6CE;" />

                        <h:outputText value="En Espera de Materiales"  styleClass="tituloCampo"   />
                        <h:outputText value="" style="width:40px;border:1px solid #000000;background-color: #E0F8F7;" />

                        <h:outputText value="En Ejecucion"  styleClass="tituloCampo"   />
                        <h:outputText value="" style="width:40px;border:1px solid #000000;background-color: #E0E0F8;" />

                        <h:outputText value="Cerrado"  styleClass="tituloCampo"   />
                        <h:outputText value=""  style="width:40px;border:1px solid #000000;background-color: #F8E0EC;" />

                    </h:panelGrid>
                    <br>

                    <rich:dataTable value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedSolicitudMantenimiento.ordenesDeTrabajoDataTable}">

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                            <%--rendered="#{data.swSi==0}"--%>
                            <%--<h:outputText value="" rendered="#{data.swNo==1}"   />--%>

                        </rich:column >

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Nro Solicitud"  />
                            </f:facet>
                            <h:outputText value="#{data.codSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.obsSolicitudMantenimiento}" />
                        </rich:column >
                        <rich:column style="#{data.estilo}">
                            <f:facet name="header">
                                <h:outputText value="Solicitante"  />
                            </f:facet>
                            <h:outputText value="#{data.personal_usuario.nombrePersonal}" />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Ejecutante"  />
                            </f:facet>
                            <h:outputText value="#{data.personal_ejecutante.nombrePersonal}" />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Fecha Emisión"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}"  />
                        </rich:column >
                        <%--rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Nro. de Lotes a Producir"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  />
                        </rich:column --%>
                        <rich:column style="#{data.estilo}">
                            <f:facet name="header">
                                <h:outputText value="Area Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Solicitud Mantenimiento"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposSolicitudMantenimiento.nombreTipoSolMantenimiento}"  />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Estado Solicitud"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Fecha Ejecución"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaCambioEstadoSolicitud}"  />
                        </rich:column >

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Seguimiento"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codSolicitudMantenimiento}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Aprobar Solicitud '></a>  "  escape="false"  />
                        </rich:column>

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo de Orden de Trabajo"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedSolicitudMantenimiento.tipoDeOrdenTrabajo_action}">
                                <h:outputText value="#{data.linkTipoOrdenDeTrabajo}"/>
                            </h:commandLink>
                        </rich:column>

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Materiales"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedSolicitudMantenimiento.materialesUtilizar_action}">
                                <h:outputText value="#{data.linkMaterialesUtilizar}"/>
                            </h:commandLink>
                        </rich:column>

                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="Trabajos"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedSolicitudMantenimiento.trabajoRealizar_action}">
                                <h:outputText value="#{data.linkTrabajosRealizar}"/>
                            </h:commandLink>
                        </rich:column>
                        
                        <rich:column style="#{data.estilo}" >
                            <f:facet name="header">
                                <h:outputText value="En Ejecucion"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedSolicitudMantenimiento.asignarTiempoReal_action}">
                                <h:outputText value="#{data.linkTiempoRealTrabajo}"/>
                            </h:commandLink>
                        </rich:column>

                    </rich:dataTable>

                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedSolicitudMantenimiento.actionSave}"/>
                    <h:commandButton value="Editar"    styleClass="btn"  action="#{ManagedSolicitudMantenimiento.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedSolicitudMantenimiento.eliminarSolicitudMantenimiento}" onclick="return eliminar('form1:dataFormula');"/>
                    <h:commandButton value="Aprobar Solicitud"    styleClass="btn"  action="#{ManagedSolicitudMantenimiento.actionEditar}" onclick="return aprobar('form1:dataFormula');"/>
                    <h:commandButton value="Reservar"    styleClass="btn"  action="#{ManagedProgramaProduccion.guardarReserva}" onclick="return reserva('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar Reserva"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarReserva}" onclick="return eliminarReserva('form1:dataFormula');"/>
                    <%--a4j:commandButton value="Explosión"  styleClass="btn"  action="#{ManagedProgramaProduccion.actionEliminar}"  oncomplete="enviar('#{ManagedProgramaProduccion.codigos}','#{ManagedProgramaProduccion.fecha_inicio}','#{ManagedProgramaProduccion.fecha_final}')" /--%>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedProgramaProduccion.closeConnection}"  />

            </a4j:form>

        </body>
    </html>

</f:view>

