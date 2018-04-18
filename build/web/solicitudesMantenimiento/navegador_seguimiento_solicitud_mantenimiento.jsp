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
                    url='navegador_aprobar_solicitud_mantenimiento.jsf?codigo='+codigoSolicitud;
                    //alert(url);
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)
                }
                
                function getOrdenPedido(codigoSolicitud){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    url='../ordenMateriales/agregar_Orden_Materiales.jsf?codigo='+codigoSolicitud;
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

                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }

        </script>
        </head>
        <body >
            
            
            
            <a4j:form id="form1">
                <div align="center">

                    <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.cargarSeguimientoSolicitudMantenimiento}"  />
                    
                    <h3 align="center">Seguimiento Ordenes de Trabajo</h3>
                    <a4j:commandLink onclick="Richfaces.showModalPanel('panelBuscarSolicitudMantenimiento')">
                            <h:outputText value="Buscar" styleClass="outputText1" />
                            <h:graphicImage url="../img/buscar.png">

                            </h:graphicImage>
                    </a4j:commandLink>
                    
                     <div style="overflow:auto;height:350px">
                    <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoList}"
                                    var="data" id="dataSolicitudMantenimiento"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDataTable}">
                        <rich:column    >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:graphicImage url="../img/go_up_red.png" width="25px" height="25px" alt="#{data.tiposNivelSolicitudMantenimiento.nombreNivelSolicitudMantenimiento}"   rendered="#{data.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento=='1'}" />
                            <h:graphicImage url="../img/go_up_orange.png" width="25px" height="25px" rendered="#{data.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento=='2'}" />
                            <h:graphicImage url="../img/go_up.png" width="25px" height="25px" rendered="#{data.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento=='3'}" />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" 
                            rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!=4}" />
                        </rich:column>
                        
                        <rich:column width="800" >
                            <f:facet name="header">
                                <h:outputText value="Nro OT"   />
                            </f:facet>
                            <h:panelGroup>
                            <h:outputText value="#{data.nroOrdenTrabajo}"  />
                            <h:outputText  rendered="#{data.solicitudProyecto eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROY"   />
                            <h:outputText  rendered="#{data.solicitudProduccion eq '1' && data.nroOrdenTrabajo>'0'}" value="-PROD"   />
                            </h:panelGroup>
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Area Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.verParteMaquinaria_action}"
                                             onclick="Richfaces.showModalPanel('panelSeleccionarParteMaquinaria')"
                                             reRender="contenidoSeleccionarParteMaquinaria"
                                             value="#{data.maquinaria.nombreMaquina}"
                                             rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!=4}"
                                             styleClass="outputText2" style="color:purple;text-decoration:underline"
                                              >
                            </a4j:commandLink>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}" rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento==4}" />
                            <h:outputText value="(" rendered="#{data.partesMaquinaria.nombreParteMaquina!=null}" />
                            <h:outputText value="#{data.partesMaquinaria.nombreParteMaquina}" />
                            <h:outputText value=")" rendered="#{data.partesMaquinaria.nombreParteMaquina!=null}" />
                        </rich:column>
                        
                        

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Instalacion"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.verInstalacionesModulos_action}"
                                             onclick="Richfaces.showModalPanel('panelSeleccionarAreaInstalacionModulo')"
                                             reRender="contenidoSeleccionarAreaInstalacionModulo"
                                             value="#{data.areasInstalaciones.nombreAreaInstalacion}"
                                             rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!=4}"
                                             styleClass="outputText2" style="color:purple;text-decoration:underline"
                                              >
                            </a4j:commandLink>
                        </rich:column>
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Ambiente"  />
                            </f:facet>
                            <h:outputText value="#{data.areasInstalacionesDetalle.nombreAreaInstalacionDetalle}"  />
                        </rich:column >

               
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Modulo Instalacion"  />
                            </f:facet>
                            <h:outputText value="#{data.modulosInstalaciones.nombreModuloInstalacion}"  />
                        </rich:column >

                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsSolicitudMantenimiento}" />
                        </rich:column >

                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Solicitante"  />
                            </f:facet>
                            <h:outputText value="#{data.personal_usuario.nombrePersonal}" />
                        </rich:column >
                        
                         <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Tipo Solicitud Mantenimiento"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposSolicitudMantenimiento.nombreTipoSolMantenimiento}"  />
                        </rich:column >

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Materiales"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.verSolicitudMantenimientoDetalleMateriales_action}" rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!=4}" >
                                <h:graphicImage url="../img/organigrama3.jpg"  />
                            </a4j:commandLink>
                        </rich:column >

                        <%--rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Tareas Programadas"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.verSolicitudMantenimientoDetalleTareas_action}" rendered="#{data.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento!=4}" >
                                <h:graphicImage url="../img/organigrama3.jpg"  />
                            </a4j:commandLink>
                        </rich:column--%>
                        
                        
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha Solicitud"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaSolicitudMantenimiento}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </rich:column >

                       <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Aprobacion"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaCambioEstadoSolicitud}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nro Sol. Compra"  />
                            </f:facet>

                            <h:outputText value="#{data.solicitudesCompra.codSolicitudCompra}"  >
                                
                            </h:outputText>
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nro. Sol. Salida"  />
                            </f:facet>
                            <h:outputText value="#{data.solicitudesSalida.codFormSalida}"  >
                                
                            </h:outputText>
                        </rich:column >


                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado Solicitud"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                        </rich:column >
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Decripcion Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcionEstado}"  />
                        </rich:column >
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Vista preliminar de Reporte"  />
                            </f:facet>
                            <a4j:commandLink onclick="openPopup('../reportes/reporteSolicitudMantenimiento/navegadorReporteOrdenTrabajo.jsf?codSolicitudMantenimiento=#{data.codSolicitudMantenimiento}')" >
                                <h:graphicImage url="../img/organigrama3.jpg"  />
                            </a4j:commandLink>
                        </rich:column>
                    </rich:dataTable>
                    </div>
                    
                    <h:panelGrid columns="2"  width="50" id="controles">
                        <a4j:commandLink  action="#{ManagedSeguimientoSolicitudMantenimiento.atras_action}" reRender="dataSolicitudMantenimiento,controles"  rendered="#{ManagedSeguimientoSolicitudMantenimiento.begin!='1'}" >
                            <h:graphicImage url="../img/previous.gif"  style="border:0px solid red"   alt="PAGINA ANTERIOR"  />
                        </a4j:commandLink>
                        <a4j:commandLink  action="#{ManagedSeguimientoSolicitudMantenimiento.siguiente_action}" reRender="dataSolicitudMantenimiento,controles" rendered="#{ManagedSeguimientoSolicitudMantenimiento.cantidadfilas>='10'}">
                            <h:graphicImage url="../img/next.gif"  style="border:0px solid red"  alt="PAGINA SIGUIENTE" />
                        </a4j:commandLink>
                    </h:panelGrid>
                    
                    <a4j:commandButton value="Cerrar OT"   styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.cerrarSolicitudMantenimiento_action}"
                    reRender="dataSolicitudMantenimiento" />
                    <a4j:commandButton value="Describir Estado" styleClass="btn" action="#{ManagedSeguimientoSolicitudMantenimiento.describirEstado_action}" reRender="contenidoDescribirEstado" oncomplete="Richfaces.showModalPanel('panelDescribirEstado')" />
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedProgramaProduccion.closeConnection}"  />
                
            </a4j:form>
            <rich:modalPanel id="panelBuscarSolicitudMantenimiento"  minHeight="300"  minWidth="1000"
                                     height="300" width="1000"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Buscar Solicitud Mantenimiento"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoBuscarSolicitudMantenimiento">
                            <h:panelGrid columns="4">


                                <%--h:outputText value="Nro de Solicitud:" styleClass="outputText1" />
                                <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.codSolicitudMantenimiento}" styleClass="inputText" size="5" onkeypress="valNum();" /--%>
                                <h:outputText value="Nro O.T.:" styleClass="outputText1" />
                                <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.nroOrdenTrabajo}" styleClass="inputText" size="5" onkeypress="valNum();" />

                                <h:outputText value="Solicitante:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.personal_usuario.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.personalSolicitanteList}"  />
                                </h:selectOneMenu>
                                <h:outputText value="Area Empresa:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.areasEmpresa.codAreaEmpresa}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.areasEmpresaBuscadorList}"  />
                                    <a4j:support event="onchange" action="#{ManagedSeguimientoSolicitudMantenimiento.codAreaEmpresa_onChange}" reRender="codMaquinariaBuscar"/>
                                </h:selectOneMenu>
                                <h:outputText value="Maquinaria:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.maquinaria.codMaquina}" id="codMaquinariaBuscar" styleClass="inputText" style="width:280px">
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.maquinariasList}"  />
                                </h:selectOneMenu>


                                <h:outputText value="fecha inicio Solicitud:" styleClass="outputText1" />
                                <rich:calendar datePattern="dd/MM/yyyy" styleClass="inputText" immediate="true"
                                value="#{ManagedSeguimientoSolicitudMantenimiento.fechaInicio}"   id="fechaInicio" enableManualInput="true"  width="1" />


                                <h:outputText value="fecha final Solicitud:" styleClass="outputText1" />
                                <rich:calendar datePattern="dd/MM/yyyy" styleClass="inputText" immediate="true"
                                value="#{ManagedSeguimientoSolicitudMantenimiento.fechaFinal}"   id="fechaFinal" enableManualInput="true"  width="1" />

                                <%--h:outputText value="fecha inicio Aprobación:" styleClass="outputText1" />
                                <rich:calendar datePattern="dd/MM/yyyy" styleClass="inputText" immediate="true"
                                value="#{ManagedSeguimientoSolicitudMantenimiento.fechaInicioAprobacion}"   id="fechaInicioAprobacion" enableManualInput="true"  width="1" />


                                <h:outputText value="fecha final Solicitud:" styleClass="outputText1" />
                                <rich:calendar datePattern="dd/MM/yyyy" styleClass="inputText" immediate="true"
                                value="#{ManagedSeguimientoSolicitudMantenimiento.fechaFinalAprobacion}"   id="fechaFinalAprobacion" enableManualInput="true"  width="1" /--%>


                                <h:outputText value="Instalacion:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.modulosInstalaciones.codModuloInstalacion}" styleClass="inputText" style="width:280">
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.areasInstalacionesList}"  />
                                </h:selectOneMenu>

                                <%--h:outputText value="afecta a produccion:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.afectaraProduccion}" styleClass="inputText" >
                                    <f:selectItem itemLabel="-TODOS-" itemValue='2' />
                                    <f:selectItem itemLabel="SI" itemValue='1' />
                                    <f:selectItem itemLabel="NO" itemValue='0' />
                                </h:selectOneMenu--%>
                                <h:outputText value="Tipo Solicitud Mantenimiento:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.tiposSolicitudMantenimiento.codTipoSolMantenimiento}" styleClass="inputText" style="width:280">
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tiposSolicitudMantenimientoList}"  />
                                </h:selectOneMenu>
                                <h:outputText value="estado:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.estadosSolicitudMantenimientoList}" />
                                </h:selectOneMenu>
                                <h:outputText value="Descripción:" styleClass="outputText1" />
                                <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.obsSolicitudMantenimiento}" styleClass="inputText"/>
                                <h:outputText value="Descripción Estado:" styleClass="outputText1" />
                                <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoBean.descripcionEstado}" styleClass="inputText"/>


                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Buscar" onclick="javascript:Richfaces.hideModalPanel('panelBuscarSolicitudMantenimiento');"
                                action="#{ManagedSeguimientoSolicitudMantenimiento.buscarSolicitudMantenimiento_action}" reRender="dataSolicitudMantenimiento" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelBuscarSolicitudMantenimiento')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            

             <rich:modalPanel id="panelSeleccionarParteMaquinaria" minHeight="150"  minWidth="400"
                                     height="300" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Tarea"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoSeleccionarParteMaquinaria">
                              <div align="center">
                            <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.partesMaquinariaList}"
                                    var="data" id="dataPartesMaquinaria"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedSeguimientoSolicitudMantenimiento.partesMaquinariaDataTable}"
                                    >
                                        
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Codigo"  />
                                        </f:facet>
                                        <a4j:commandLink value="#{data.codigo}" onclick="Richfaces.hideModalPanel('panelSeleccionarParteMaquinaria')"
                                                         action="#{ManagedSeguimientoSolicitudMantenimiento.seleccionarParteMaquinaria_action}"
                                                         reRender="dataSolicitudMantenimiento" styleClass="outputText1" />
                                    </rich:column>                                    
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Tipo Equipo"  />
                                        </f:facet>
                                        <h:outputText value="#{data.tiposEquiposMaquinaria.nombreTipoEquipo}" />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Nombre"  />
                                        </f:facet>
                                        <h:outputText value="#{data.nombreParteMaquina}" />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Observaciones"  />
                                        </f:facet>
                                        <h:outputText value="#{data.obsParteMaquina}" />
                                    </rich:column>
                            </rich:dataTable>
                            
                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleTareas.registrarSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarParteMaquinaria')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionarParteMaquinaria')" />
                                </div>

                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>


            <rich:modalPanel id="panelDescribirEstado" minHeight="240"  minWidth="700"
                                     height="240" width="700"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Describir Estado"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoDescribirEstado">

                              <div align="center">
                                  <b>
                                  Solicitud Mantenimiento: </b>
                                  <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.obsSolicitudMantenimiento}" />
                                  <h:panelGrid columns="2">
                                      <h:outputText value="Descripcion" styleClass="outputText2" />
                                      <h:inputTextarea value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.descripcionEstado}" rows="8" cols="90" styleClass="inputText" />
                                      <h:outputText value="Enviar Correo Electronico al Solicitante" styleClass="outputText2" />
                                      <h:selectBooleanCheckbox value="#{ManagedSeguimientoSolicitudMantenimiento.enviarCorreoSolicitante}" />
                                  </h:panelGrid>

                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardardescribirEstado_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelDescribirEstado')"
                                reRender="dataSolicitudMantenimiento" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelDescribirEstado')" />
                                </div>

                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
              <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
         <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden"  >
         </h:panelGroup>

              <%--rich:modalPanel id="panelSeleccionarAreaInstalacionModulo" minHeight="150"  minWidth="400"
                                     height="300" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Tarea"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoSeleccionarAreaInstalacionModulo">
                              <div align="center">
                               <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.areasInstalacionesModulosList}"
                                    var="data" id="dataPartesMaquinaria"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedSeguimientoSolicitudMantenimiento.areasInstalacionesDataTable}"
                                    >

                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Codigo"  />
                                        </f:facet>
                                        <a4j:commandLink value="#{data.codigo}" onclick="Richfaces.hideModalPanel('panelSeleccionarAreaInstalacionModulo')"
                                                         action="#{ManagedSeguimientoSolicitudMantenimiento.seleccionarAreaInstalacionModulo_action}"
                                                         reRender="dataSolicitudMantenimiento" />
                                    </rich:column>                                    
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Nombre"  />
                                        </f:facet>
                                        <h:outputText value="#{data.modulosInstalaciones.nombreModuloInstalacion}" />
                                    </rich:column>
                                    
                            </rich:dataTable>

                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleTareas.registrarSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionarAreaInstalacionModulo')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionarAreaInstalacionModulo')" />
                                </div>

                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel--%>
            <table border="1" style="font-family: Arial">
                <tbody>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

        </body>
    </html>
    
</f:view>