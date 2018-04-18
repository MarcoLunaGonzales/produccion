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
                A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error "+message+" continue con su transaccion ");
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }
            function verificaDetalle(table,id){
                var totalDetalle = 0;
                var elements1=document.getElementById(table);
                    var rowsElement1=elements1.rows;
                    //alert(" longitud "+rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[4];
                        if(typeof cel1 == 'undefined'){
                            cel1=cellsElement1[0];
                        }
                        if(typeof cel1!= 'undefined' && cel1.getElementsByTagName('input')[0]!=null){
                            //alert(cel1.getElementsByTagName('input')[0].value);
                            var id1 = cel1.getElementsByTagName('input')[0].getAttribute("id");
                            var ids1 = id1.split(":");
                            //alert(id+" "+ids1[2]);
                            if(id==ids1[2]){ //cel1.getElementsByTagName('input').length>0
                                var input = cel1.getElementsByTagName('input')[0];
                                totalDetalle = totalDetalle + eval(input.value);
                                //alert(input.value);
                            }
                            //alert(totalDetalle);
                            //cel1.getElementsByTagName('input')[0].value();
                        }
                    }
                    return totalDetalle;
            }
            function actualizaValor(obj,table){
               var id=obj.getAttribute("id");
               var ids = id.split(":");
               //alert(ids[2]);
               var elements1=document.getElementById(table);
                    var rowsElement1=elements1.rows;
                    //alert(" longitud "+rowsElement1.length);
                    for(var i=1;i<rowsElement1.length;i++){
                        var cellsElement1=rowsElement1[i].cells;
                        var cel1=cellsElement1[2];
                        
                        if(typeof cel1 == 'undefined'){
                            
                            cel1=cellsElement1[0];
                        }
                        
                        if(typeof cel1!= 'undefined' && cel1.getElementsByTagName('input')[0]!=null){
                            var id1 = cel1.getElementsByTagName('input')[0].getAttribute("id");
                            var ids1 = id1.split(":");
                            //alert(ids[2] + "  " +ids1[2]);
                            if(ids[2]==ids1[2]){ //cel1.getElementsByTagName('input').length>0
                                var input = cel1.getElementsByTagName('input')[0];
                                input.value = verificaDetalle(table,ids[2]);
                                break;
                            }
                            //cel1.getElementsByTagName('input')[0].value();
                        }
                    }
               //alert();
               //alert(obj.parentNode.parentNode);// .getElementsByTagName("input")[0].value;
               //var fechaFinal = fecha.parentNode.parentNode.getElementsByTagName("td")[5].getElementsByTagName("input")[0].value;
               //var fechaInicio1 = new Date(fechaInicio);
               //var fechaFinal1 = new Date(fechaFinal);
               //alert(fechaInicio+":00");
               //alert(fechaFinal+":00");
               //alert(fechaFinal1.getTime()-fechaInicio1.getTime());
               //var dif = (fechaFinal1-fechaInicio1)/3600000;
               //var dif = Math.round(((fechaFinal1.getTime()-fechaInicio1.getTime())/3600000.0)*100)/100;
               //fecha.parentNode.parentNode.getElementsByTagName("td")[2].getElementsByTagName("span")[0].innerHTML=dif;
           }
           function reporteEtiquetasDesarollo(codLote,CodprogramaProd)
           {
               openPopup("reporteEtiquetasDesarrollo.jsp?codProgProd="+CodprogramaProd+"&codLote="+codLote+"&data="+(new Date()).getTime().toString());
           }
         </script>
        </head>
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccion.cargarProgramaProduccionSeguimientoList}"  />
                   
                    <h:outputText styleClass="outputTextTituloSistema"  value="Seguimiento de Programa de Producción" />
                   
                        <rich:panel headerClass="headerClassACliente" rendered="#{ManagedProgramaProduccion.programaProduccionSeguimientoBuscar.programaProduccionPeriodo!= null}">
                            <f:facet name="header">
                                <h:outputText value="Datos Programa Producción"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Nombre Programa"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionSeguimientoBuscar.programaProduccionPeriodo.nombreProgramaProduccion}"/>
                                <h:outputText styleClass="outputTextBold" value="Observación"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionSeguimientoBuscar.programaProduccionPeriodo.obsProgramaProduccion}"/>
                                
                            </h:panelGrid>

                        </rich:panel>
                        <rich:panel headerClass="headerClassACliente" rendered="#{ManagedProgramaProduccion.programaProduccionSeguimientoBuscar.codLoteProduccion !=''}">
                            <f:facet name="header">
                                <h:outputText value="Busqueda"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Lote Busqueda"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionSeguimientoBuscar.codLoteProduccion}"/>
                                
                            </h:panelGrid>
                        </rich:panel>
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionSeguimientoList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" style="margin-top:1em"
                                    headerClass="headerClassACliente" binding="#{ManagedProgramaProduccion.programaProduccionSeguimientoDataTable}">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Producto"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Lote"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Nro de Lote"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Fecha Inicio"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Fecha Final"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Tipo Programa Producción"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Estado Materia Prima"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Area"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Observaciones"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value="Estado"  />
                                    </rich:column>
                                    <rich:column rowspan="2">
                                        <h:outputText value=""  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='80' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='81' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='82' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='95'}">
                                        <h:outputText value="Proceso Producción"  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='75'}">
                                        <h:outputText value="Proceso Microbiologia"  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='40'}">
                                        <h:outputText value="Proceso Control de Calidad"  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='84' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='102' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='85'}">
                                        <h:outputText value="Proceso de Acondicionamiento"  />
                                    </rich:column>
                                    <rich:column rowspan="2" >
                                        <h:outputText value="Proceso Pesaje"  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='76' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='85'}">
                                        <h:outputText value="Proceso Almacen Materia Prima"  />
                                    </rich:column>
                                    <rich:column rowspan="2" rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='84' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='102'}">
                                        <h:outputText value="Proceso Almacen de Empaque Secundario"  />
                                    </rich:column>
                                    <rich:column colspan="2">
                                        <h:outputText value="Etiquetas"  />
                                    </rich:column>
                                    <rich:column breakBefore="true">
                                        <h:outputText value="Acondicionamiento"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Desarrollo"  />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>

                        <rich:column styleClass="#{data.styleClass}" >
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" >
                            <h:outputText value="#{data.cantidadLote}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" >
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            
                            <h:outputText value="#{data.fechaInicio}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            
                            <h:outputText value="#{data.fechaFinal}"  />
                        </rich:column >
                        <rich:column  styleClass="#{data.styleClass}" >
                                
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            
                            <h:outputText value="#{data.materialTransito}" id="n" />
                        </rich:column>
                        
                        <rich:column styleClass="#{data.styleClass}" >

                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>

                        <rich:column  styleClass="#{data.styleClass}" >
                            
                            <h:outputText value="#{data.observacion}" />
                        </rich:column >
                        <rich:column  styleClass="#{data.styleClass}" >
                            
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codProgramaProduccion}','#{data.formulaMaestra.codFormulaMaestra}','#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}','#{data.formulaMaestra.cantidadLote}','#{data.formulaMaestra.componentesProd.codCompprod}','#{data.codLoteProduccion}','#{data.tiposProgramaProduccion.codTipoProgramaProd}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Detalle'></a>  "  escape="false"  />
                        </rich:column >
                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='80' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='81' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='82' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='95'}">
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                           rendered="#{data.formulaMaestra.componentesProd.forma.codForma != 2}"
                                           oncomplete = "if(#{ManagedProgramaProduccion.mensaje != ''} ){alert('#{ManagedProgramaProduccion.mensaje}');}else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}">
                                <f:param name="codAreaEmpresa" value="96" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='75'}">
                                
                             <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                   oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}"   >
                                <f:param name="codAreaEmpresa" value="75" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='40'}">
                            
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                               oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}"  >
                                <f:param name="codAreaEmpresa" value="40" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>

                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='84' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='102' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='85'}">

                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                             oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}">
                                <f:param name="codAreaEmpresa" value="84" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column >
                            
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                           oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}" >
                                <f:param name="codAreaEmpresa" value="97" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='76' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='85'}">
                            
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                        oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}" >
                                <f:param name="codAreaEmpresa" value="76" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column rendered="#{ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='84' || ManagedProgramaProduccion.usuario.codAreaEmpresaGlobal=='102'}">
                            
                            <a4j:commandLink action="#{ManagedProgramaProduccion.verActividadesProduccion_action1}"
                                    oncomplete = "
                                              if('#{ManagedProgramaProduccion.mensaje}'!= '' )
                                              {alert('#{ManagedProgramaProduccion.mensaje}');}
                                               else{location='../actividades_programa_produccion/navegador_actividades_programa.jsf';}">
                                <f:param name="codAreaEmpresa" value="1001" />
                                <f:param name="url" value="../programaProduccion/navegador_seguimiento_programa_produccion.jsf" />
                                <h:graphicImage url="../img/organigrama3.jpg" alt="proceso de produccion" />
                            </a4j:commandLink>
                        </rich:column>

                        <rich:column>
                            
                                <a4j:commandLink action="#{ManagedProgramaProduccion.verReporteEtiquetasAcond_action}" oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){Richfaces.showModalPanel('PanelRegistrarCantidadPorCaja');}else{alert('#{ManagedProgramaProduccion.mensaje}');}" reRender="contenidoCantidadPorCaja" timeout="3200" >
                                <h:graphicImage url="../img/imp2.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column>
                            
                            <a4j:commandLink  oncomplete="reporteEtiquetasDesarollo('#{data.codLoteProduccion}',#{data.codProgramaProduccion});" > <%-- oncomplete="openPopup('reporteEtiquetasAcond.jsp')" --%>
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>


                        <%--rich:column>
                            <f:facet name="header">
                                <h:outputText value="Orden de Manufactura"  />
                            </f:facet>
                            
                            <a4j:commandLink action="#{ManagedProgramaProduccion.ordenManufactura_action}" >
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="orden de manufactura" />
                            </a4j:commandLink>

                        </rich:column--%>

                    </rich:dataTable>
                    
                    <br>
                    <%--h:commandButton value="Agregar" action="#{ManagedProgramaProduccion.agregarProgramaProduccion_action}"  styleClass="btn"  /--%> <%--  action="#{ManagedProgramaProduccion.actionagregar}" oncomplete="location='navegador_programa_produccion_lotes.jsf'" --%>
                    <%--h:commandButton value="Editar Lotes"    styleClass="btn"  action="#{ManagedProgramaProduccion.actionEditar}" onclick="return eliminarItem('form1:dataFormula');"/--%>
                    <%--h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarProgProd}" onclick="if(confirm('Esta seguro de eliminar el registro?')==false){return false}else{return eliminar('form1:dataFormula');}"/--%>
                    <%--h:commandButton value="Reservar"    styleClass="btn"  action="#{ManagedProgramaProduccion.guardarReserva}" onclick="return reserva('form1:dataFormula');"/--%>
                    <%--h:commandButton value="Eliminar Reserva"    styleClass="btn"  action="#{ManagedProgramaProduccion.eliminarReserva}" onclick="return eliminarReserva('form1:dataFormula');"/--%>
                    <%--a4j:commandButton value="Terminar Producto" styleClass="btn" oncomplete="if(#{ManagedProgramaProduccion.mensajes!=''}){javascript:Richfaces.showModalPanel('panelActividadesProducto',{width:100, top:100});}else{javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');}"
                                       action="#{ManagedProgramaProduccion.terminarProducto_action}"
                                       reRender="contenidoActividadesProducto,contenidoIngresoAcondicionamiento"/--%>
                    
                    <%--a4j:commandButton value="Editar Materiales" action="#{ManagedProgramaProduccion.cargarFormulaProducto}"  styleClass="btn"  oncomplete="Richfaces.showModalPanel('panelModificarFormulaMaestra')"  reRender="contenidoModificarMateriales" /--%>
                    <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorSeguimientoProgramaPeriodo.jsf?cancel='+(new Date()).getTime().toString()" styleClass="btn"/>
                    </h:panelGroup>
                   
                    
                </div>

            </a4j:form>
            
            
            <rich:modalPanel id="PanelRegistrarCantidadPorCaja" minHeight="340"  minWidth="520"
                                     height="340" width="520"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Detalle Impresión Etiquetas</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoCantidadPorCaja">
                               <h:panelGrid columns="3">
                                   <h:outputText value="Lote" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.codLoteProduccion}" styleClass="outputText2" />
                                   <h:outputText value="Producto" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:outputText value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                   <h:outputText value="Presentación Producto" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:selectOneMenu style="width:350px;" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.presentacionesProducto.codPresentacion}" styleClass="inputText" >
                                       <f:selectItems value="#{ManagedProgramaProduccion.presentacionesSecundariasSelectList}"/>
                                    </h:selectOneMenu>
                                   <h:outputText value="Cantidad de Productos" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:inputText value="#{ManagedProgramaProduccion.ingresosAcondicionamientoEtiqueta.cantTotalIngreso}" styleClass="inputText" />
                                   <h:outputText value="Cantidad por Caja" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:inputText value="#{ManagedProgramaProduccion.ingresosAcondicionamientoEtiqueta.cantidadEnvase}" styleClass="inputText" />
                                   <h:outputText value="Unidades" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:inputText value="#{ManagedProgramaProduccion.ingresosAcondicionamientoEtiqueta.tiposEnvase.nombreTipoEnvase}" styleClass="inputText" />
                                   <h:outputText value="fecha Vencimiento" styleClass="outputTextBold" />
                                   <h:outputText value="::" styleClass="outputTextBold" />
                                   <h:inputText value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.fechaVencimiento}" styleClass="inputText2" onblur="valFecha(this)" >
                                        <f:convertDateTime  pattern="dd/MM/yyyy" />
                                    </h:inputText>
                                    <h:outputText value="Producción" styleClass="outputTextBold" />
                                    <h:outputText value="::" styleClass="outputTextBold" />
                                    <h:selectOneMenu value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText2">
                                        <f:selectItems value="#{ManagedProgramaProduccion.tiposProgramaProduccionSelectList}"/>
                                        <a4j:support event="onchange" reRender="contenidoCantidadPorCaja"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="Cliente" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.codTipoProgramaProd eq '2'}"  id="spanCliente"/>
                                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.codTipoProgramaProd eq '2'}"  id="spanCliente2"/>
                                    <h:selectOneMenu value="#{ManagedProgramaProduccion.ingresosAcondicionamientoEtiqueta.ingresosAcondicionamiento.clientes.codCliente}" styleClass="inputText" rendered="#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.codTipoProgramaProd eq '2'}" id="selectCliente">
                                       <f:selectItems value="#{ManagedProgramaProduccion.clienteSelectList}"/>
                                    </h:selectOneMenu>
                               </h:panelGrid>
                                    <div align="center" style="margin-top:1em;">
                                        <a4j:commandButton styleClass="btn" value="Aceptar"  action="#{ManagedProgramaProduccion.verReporteEtiquetas}"
                                        oncomplete="openPopup('reporteEtiquetasAcond.jsf')"/>

                                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelRegistrarCantidadPorCaja')" class="btn" />
                                    </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelModificarFormulaMaestra" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Modificar Materiales" />
                        </f:facet>
                                    
                        <h:form id="form4">
                        <div align="center">
                        <h:panelGroup id="contenidoModificarMateriales">
                            <rich:panel headerClass="headerClassACliente">
                                        <f:facet name="header">
                                            <h:outputText value="Datos de Producto" />
                                        </f:facet>
                                        <h:panelGrid columns="4">
                                            <h:outputText styleClass="outputTextTitulo" value="Producto" />
                                            <h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.componentesProd.nombreProdSemiterminado}" />
                                            <h:outputText styleClass="outputTextTitulo" value="Lote" />
                                            <h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.codLoteProduccion}" />
                                            <h:outputText styleClass="outputTextTitulo" value="Tipo Programa Produccion" />
                                            <h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.nombreProgramaProd}" />
                                            <h:outputText styleClass="outputTextTitulo" value="Cant Lote" />
                                            <h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.cantidadLote}" />
                                            <h:outputText styleClass="outputTextTitulo" value="Area" />
                                            <h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}" />
                                        </h:panelGrid>
                                    </rich:panel>
                        <h:outputText value="#{ManagedProgramaProduccion.mensajes}" />
                        MATERIA PRIMA<br/>
                            <rich:dataTable  value="#{ManagedProgramaProduccion.formulaMaestraDetalleMPMoficarList}"
                                         width="100%"  var="fila"
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         id="materialesProductoMP"   align="center" binding="#{ManagedProgramaProduccion.materialesDataTable}"
                                         rowKeyVar="idFila">
                                <f:facet name="header">
                                    <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Material"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unid."/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fracciones"/>
                                    </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                          <rich:subTable var="subData" value="#{fila.fraccionesDetalleList}" rowKeyVar="rowkey" >
                                <rich:column rowspan="#{fila.fraccionesDetalleSize}" rendered="#{rowkey eq 0}">
                                    <h:selectBooleanCheckbox value="#{fila.checked}"/>
                                </rich:column>
                                <rich:column rowspan="#{fila.fraccionesDetalleSize}" rendered="#{rowkey eq 0}">
                                    <%--h:outputText value="#{fila.materiales.nombreMaterial}"/--%>
                                    <h:selectOneMenu value="#{fila.materiales.codMaterial}" styleClass="inputText" >
                                        <f:selectItems value="#{ManagedProgramaProduccion.materiaMPList}"/>
                                        <a4j:support action="#{ManagedProgramaProduccion.material_change}" reRender="contenidoModificarMateriales" event="onchange" />
                                    </h:selectOneMenu>
                                </rich:column>
                                <rich:column rowspan="#{fila.fraccionesDetalleSize}" rendered="#{rowkey eq 0}">
                                    <h:inputText value="#{fila.cantidad}" styleClass="inputText" size="10" id="cantidadValor"  />
                                    
                                </rich:column>
                                <rich:column rowspan="#{fila.fraccionesDetalleSize}" rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{fila.unidadesMedida.nombreUnidadMedida} "/>
                                </rich:column>
                                <rich:column>
                                    <h:inputText styleClass="inputText" value="#{subData.cantidad}" onkeyup="actualizaValor(this,'form4:materialesProductoMP');" id="cantidadSubValor"  >
                                        <%--a4j:support event="onblur" action="#{ManagedProgramaProduccion.actualizaCantidad}" reRender="contenidoModificarMateriales" /--%>
                                    </h:inputText> <%-- onblur="actualizaValor(this,'form4:materialesProductoMP');" id="cantidadSubValor" --%>
                                </rich:column>
                            </rich:subTable>
                        </rich:dataTable>
                        <a4j:commandLink   accesskey="q"  action="#{ManagedProgramaProduccion.adicionarMaterial_action}" reRender="materialesProductoMP"  timeout="7200"  >
                                <h:graphicImage url="../img/mas.png"/>
                                <f:param name="codTipoMaterial" value="1" />
                        </a4j:commandLink>
                        <a4j:commandLink accesskey="w" action="#{ManagedProgramaProduccion.eliminarMaterial_action}" reRender="materialesProductoMP"  timeout="7200">
                            <h:graphicImage url="../img/menos.png"/>
                            <f:param name="codTipoMaterial" value="1" />
                        </a4j:commandLink>
                        <br/>MATERIAL DE EMPAQUE PRIMARIO<br/>

                            <rich:dataTable  value="#{ManagedProgramaProduccion.formulaMaestraDetalleEPMoficarList}"
                                         width="100%"  var="fila"
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"

                                         id="materialesProductoEP"   align="center">
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value=""/>
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{fila.checked}"/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Material"/>
                                </f:facet>
                                <h:selectOneMenu value="#{fila.materiales.codMaterial}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.materiaEPList}" />
                                </h:selectOneMenu>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Cantidad"/>
                                </f:facet>
                                <h:inputText value="#{fila.cantidad}" styleClass="inputText" size="10" />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Unid."/>
                                </f:facet>
                                <h:outputText value="#{fila.unidadesMedida.nombreUnidadMedida} "/>
                            </rich:column>
                        </rich:dataTable>
                        <a4j:commandLink   accesskey="q"  action="#{ManagedProgramaProduccion.adicionarMaterial_action}" reRender="materialesProductoEP"  timeout="7200"  >
                                <f:param name="codTipoMaterial" value="2" />
                                <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink accesskey="w" action="#{ManagedProgramaProduccion.eliminarMaterial_action}" reRender="materialesProductoEP"  timeout="7200">
                            <f:param name="codTipoMaterial" value="2" />
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                            <br/>MATERIAL DE EMPAQUE SECUNDARIO<br/>
                            <rich:dataTable  value="#{ManagedProgramaProduccion.formulaMaestraDetalleESMoficarList}"
                                         width="100%"  var="fila"
                                         headerClass="headerClassACliente"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"

                                         id="materialesProductoES"   align="center">
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value=""/>
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{fila.checked}"/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Material"/>
                                </f:facet>
                                <h:selectOneMenu value="#{fila.materiales.codMaterial}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.materiaESList}" />
                                </h:selectOneMenu>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Cantidad"/>
                                </f:facet>
                                <h:inputText value="#{fila.cantidad}" styleClass="inputText" size="10" />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Unid."/>
                                </f:facet>
                                <h:outputText value="#{fila.unidadesMedida.nombreUnidadMedida} "/>
                            </rich:column>
                        </rich:dataTable>
                        <a4j:commandLink   accesskey="q"  action="#{ManagedProgramaProduccion.adicionarMaterial_action}" reRender="materialesProductoES"  timeout="7200"  >
                                <f:param name="codTipoMaterial" value="3" />
                                <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink accesskey="w" action="#{ManagedProgramaProduccion.eliminarMaterial_action}" reRender="materialesProductoES"  timeout="7200">
                            <f:param name="codTipoMaterial" value="3" />
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                        </h:panelGroup>
                        <br/>
                        
                        <a4j:commandButton  value="Guardar" styleClass="btn"
                        action="#{ManagedProgramaProduccion.actualizaMaterialesProducto_action}"
                        ajaxSingle="false" status="statusPeticion"
                        oncomplete="javascript:Richfaces.hideModalPanel('panelModificarFormulaMaestra');
                        " />
                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelModificarFormulaMaestra')" />
                        <%-- openPopup('productoModificado.jsf?codLoteProduccion=#{ManagedProgramaProduccion.programaProduccionSeleccionado.codLoteProduccion}&codCompProd=#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.componentesProd.codCompprod}&codFormulaMaestra=#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.codFormulaMaestra}&codTipoProgramaProd=#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.codTipoProgramaProd}&codProgramaProd=#{ManagedProgramaProduccion.programaProduccionSeleccionado.codProgramaProduccion}&nombreProdSemiterminado=#{ManagedProgramaProduccion.programaProduccionSeleccionado.formulaMaestra.componentesProd.nombreProdSemiterminado}&nombreTipoProgramaProd=#{ManagedProgramaProduccion.programaProduccionSeleccionado.tiposProgramaProduccion.nombreTipoProgramaProd}'); --%>
                        </div>
                        </h:form>
                    </rich:modalPanel>
        </body>
    </html>
    
</f:view>

