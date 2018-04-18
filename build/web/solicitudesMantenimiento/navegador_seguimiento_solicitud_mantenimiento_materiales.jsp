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
            <script>
                function getCodigo(cod_maquina,codigo){
                 //  alert(codigo);
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
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

                }
           }

           function validarSeleccion(nametable){
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
        function verManteminiento(cod_maquina,codigo){
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
        }

        function seleccionarAsignado(valorCheck)
                {
                    //alert(document.getElementById('form2:asignado:0').checked);
                    //if(valorCheck=="interno"){
                    alert(valorCheck.checked +" "+ valorCheck.value);
                    if(valorCheck.checked){
                        document.getElementById('form2:selectPersonal').disabled= false;
                        document.getElementById('form2:selectProovedor').disabled= true;
                    }else{
                        document.getElementById('form2:selectPersonal').disabled= true;
                        document.getElementById('form2:selectProovedor').disabled=false;
                    }
                }
        function seleccionarAsignado1(valorCheck)
                {
                    alert(valorCheck.checked +" "+ valorCheck.value);
                    if(valorCheck.checked){
                        document.getElementById('form3:selectPersonal').disabled= false;
                        document.getElementById('form3:selectProovedor').disabled= true;
                    }else{
                        document.getElementById('form3:selectPersonal').disabled= true;
                        document.getElementById('form3:selectProovedor').disabled=false;
                    }
                }
         function seleccionarAsignado2()
                {                    
                    if(document.getElementById('form2:asignado:0').checked){
                        document.getElementById('form2:selectPersonal').disabled= false;
                        document.getElementById('form2:selectProovedor').disabled= true;
                    }
                    if(document.getElementById('form2:asignado:1').checked){
                        document.getElementById('form2:selectPersonal').disabled= true;
                        document.getElementById('form2:selectProovedor').disabled=false;
                    }
                }
          function seleccionarAsignado3()
                {
                    if(document.getElementById('form3:asignado:0').checked){
                        document.getElementById('form3:selectPersonal').disabled= false;
                        document.getElementById('form3:selectProovedor').disabled= true;
                    }
                    if(document.getElementById('form3:asignado:1').checked){
                        document.getElementById('form3:selectPersonal').disabled= true;
                        document.getElementById('form3:selectProovedor').disabled=false;
                    }
                }
           function validarRegistroSolicitudMantenimientoDetalleMateriales(){
               if(document.getElementById("form2:codMaterial").value==0){
                   alert("seleccione el material");
                   return false;
               }
               if(document.getElementById("form2:cantidad").value==0){
                   alert("coloque una cantidad de material");
                   return false;
               }
           }
           function validarEditarSolicitudMantenimientoDetalleMateriales(){
               if(document.getElementById("form3:codMaterial").value==0){
                   alert("seleccione el material");
                   return false;
               }
               if(document.getElementById("form3:cantidad").value==0){
                   alert("coloque una cantidad de material");
                   return false;
               }
           }
       </script>
        </head>
        <body>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.cargarContenidoSolicitudMantenimientoDetalleMateriales}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Materiales Para Orden de Trabajo" />
                    <br><br>
                        <h:panelGrid columns="4"  styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;" id="datosSolicitudMantenimiento">
                            <f:facet name="header">
                                <h:outputText value="Datos Orden de Trabajo"  />
                            </f:facet>
                            <h:outputText  value="Nro OT :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.nroOrdenTrabajo}" styleClass="outputText2"/>
                            <h:outputText  value="Area :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText  value="Maquinaria :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                            <h:outputText  value="Instalacion :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                            <h:outputText  value="Modulo Instalacion :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.modulosInstalaciones.nombreModuloInstalacion}" styleClass="outputText2"/>
                            <h:outputText  value="Descripcion :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.obsSolicitudMantenimiento}" styleClass="outputText2"/>
                            <h:outputText  value="Solicitante :" styleClass="outputText2" />
                            <h:panelGroup>
                                <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.personal_usuario.nombrePersonal}" styleClass="outputText2"/>&nbsp;
                                <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.personal_usuario.apPaternoPersonal}" styleClass="outputText2"/>&nbsp;
                                <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.personal_usuario.apMaternoPersonal}" styleClass="outputText2"/>
                            </h:panelGroup>
                            <h:outputText  value="Tipo Solicitud Mantenimiento :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.tiposSolicitudMantenimiento.nombreTipoSolMantenimiento}" styleClass="outputText2"/>

                            <h:outputText  value="Nro Solicitud Compra :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.codSolicitudCompra}" styleClass="outputText2"/>
                            <h:outputText  value="Fecha Solicitud Compra :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.fechaSolicitudCompra}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                            <h:outputText  value="Nro Solicitud Salida Almacen :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida}" styleClass="outputText2"/>
                            <h:outputText  value="Fecha Soliciud Almacen :" styleClass="outputText2" />
                            <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.fechaSolicitud}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                        </h:panelGrid><br/><br/>
                        
                    <rich:dataTable value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMaterialesList}" var="data"
                                    id="dataSolicitudMantenimientoDetalleMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"  >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>


                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcion}"/>
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </rich:column>

                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Unidades"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </rich:column>
                        
                        <rich:column footerClass="">
                            <f:facet name="header">
                                <h:outputText value="Disponible"  />
                            </f:facet>
                            <h:outputText value="#{data.disponible}" />
                        </rich:column>

                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>

                    <%--
                     <a4j:commandButton value="Guardar" styleClass="btn" 
                     action="#{ManagedSeguimientoSolicitudMantenimiento.guardarSeguimientoTareasSolicitudMantenimiento_action}"                     
                     oncomplete="location='navegador_seguimiento_solicitud_mantenimiento.jsf'"  />
                    --%>
                    
                     
                     <h:panelGroup id="botones">
                    <a4j:commandButton value="Agregar" styleClass="btn" 
                    
                    action="#{ManagedSolicitudMantenimientoDetalleMateriales.agregarSolicitudMantenimientoDetalleMateriales_action}"
                    reRender="contenidoAgregarSolicitudMantenimientoDetalleMateriales"
                    oncomplete="Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoDetalleMateriales')"
                    />
                    <%-- onclick="if(#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida==0&&ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.codSolicitudCompra==0}){Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoDetalleMateriales')}else{alert('ya se hizo una solicitud a almacen o solicitud de compra')}" --%>

                    <a4j:commandButton value="Editar"  styleClass="btn" 
                    action="#{ManagedSolicitudMantenimientoDetalleMateriales.editarSolicitudMantenimientoDetalleMateriales_action}"
                    reRender="contenidoEditarSolicitudMantenimientoDetalleMateriales"
                    oncomplete="Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleMateriales')"
                    />
                    <%-- onclick="if(#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida==0&&ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.codSolicitudCompra==0}){Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleMateriales')}else{alert('ya se hizo una solicitud a almacen o solicitud de compra')}" --%>
                    <a4j:commandButton value="Eliminar"  styleClass="btn"
                    
                    onclick="if(#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida==0&&ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.codSolicitudCompra==0}){if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataSolicitudMantenimientoDetalleMateriales')==false){return false;}}else{alert('ya se hizo una solicitud a almacen o solicitud de compra'); return false;}"
                    action="#{ManagedSolicitudMantenimientoDetalleMateriales.eliminarSolicitudMantenimientoDetalleMateriales_action}"
                    reRender="dataSolicitudMantenimientoDetalleMateriales"                    
                    />
                    <a4j:commandButton value="Solicitud Almacen"  styleClass="btn"                    
                    action="#{ManagedSolicitudMantenimientoDetalleMateriales.verSolicitudAlmacen_action}"
                    reRender="contenidoSolicitudAlmacenDetalleMateriales"
                    oncomplete="Richfaces.showModalPanel('panelSolicitudAlmacenDetalleMateriales')"
                    />
                    <%-- onclick="if(#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida==0}){Richfaces.showModalPanel('panelSolicitudAlmacenDetalleMateriales')}else{alert('ya se hizo la solicitud a almacen'); return false;}" --%>

                     <a4j:commandButton value="Solicitud Compra"  styleClass="btn" 
                     onclick="if(#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesSalida.codFormSalida!=0 || ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimiento.solicitudesCompra.codSolicitudCompra!=0}){alert('ya se hizo la solicitud de compra o almacen'); return false;}else{javascript:Richfaces.showModalPanel('panelSolicitudCompraDetalleMateriales')}
                     "
                     action="#{ManagedSolicitudMantenimientoDetalleMateriales.verSolicitudCompra_action}"
                     reRender="contenidoSolicitudCompraDetalleMateriales"                     
                     />
                     
                    <%--a4j:commandButton styleClass="btn" value="Aceptar" onclick="location='navegador_seguimiento_solicitud_mantenimiento.jsf'" /--%>
                    <input type="button" class="btn" value="Aceptar" onclick="location='<%=request.getParameter("direccion")%>'" />
                    </h:panelGroup>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />

            </a4j:form>

             <rich:modalPanel id="panelAgregarSolicitudMantenimientoDetalleMateriales" minHeight="240"  minWidth="680"
                                     height="240" width="680"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Material"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoAgregarSolicitudMantenimientoDetalleMateriales">
                             
                            <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                                <f:facet name="header" >
                                    <h:outputText value="Introduzca Datos " styleClass="outputText2"   />
                                </f:facet>
                                <h:outputText  value="Material" styleClass="outputText2"  />
                                <h:outputText styleClass="outputText2" value="::"  />

                                <h:selectOneMenu  styleClass="inputText" id="codMaterial" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.materiales.codMaterial}">
                                    <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleMateriales.materialesList}"  />
                                    <a4j:support action="#{ManagedSolicitudMantenimientoDetalleMateriales.material_change}" event="onchange" reRender="contenidoAgregarSolicitudMantenimientoDetalleMateriales" />
                                </h:selectOneMenu>

                                <h:outputText value="Descripción" styleClass="outputText2"   />
                                <h:outputText styleClass="outputText2" value="::"  />
                                <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.descripcion}"/>



                                <h:outputText  value="Cantidad" styleClass="outputText2"  />
                                <h:outputText styleClass="outputText2" value="::"  />
                                <h:panelGroup>
                                    <h:inputText styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.cantidad}" id="cantidad" />
                                    <h:outputText styleClass="outputText1" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.unidadesMedida.nombreUnidadMedida}"  />
                                </h:panelGroup>
                            </h:panelGrid>
                            <br/>
                                <div align="center">
                                
                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleMateriales.registrarSolicitudMantenimientoDetalleMateriales_action}"
                                onclick="if(validarRegistroSolicitudMantenimientoDetalleMateriales()==false){return false;}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleMateriales')"
                                reRender="dataSolicitudMantenimientoDetalleMateriales" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleMateriales')" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarSolicitudMantenimientoDetalleMateriales"  minHeight="240"  minWidth="680"
                                     height="240" width="680"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Material"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarSolicitudMantenimientoDetalleMateriales">

                             <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                                <f:facet name="header" >
                                    <h:outputText value="Introduzca Datos " styleClass="outputText2"   />
                                </f:facet>
                                <h:outputText  value="Material" styleClass="outputText2"  />
                                <h:outputText styleClass="outputText2" value="::"  />

                                <h:selectOneMenu  styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.materiales.codMaterial}" id="codMaterial">
                                    <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleMateriales.materialesList}"/>
                                    <a4j:support action="#{ManagedSolicitudMantenimientoDetalleMateriales.material_change}" event="onchange" reRender="contenidoEditarSolicitudMantenimientoDetalleMateriales" />
                                </h:selectOneMenu>

                                <h:outputText value="Descripción" styleClass="outputText2"   />
                                <h:outputText styleClass="outputText2" value="::"  />
                                <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.descripcion}"/>



                                <h:outputText  value="Cantidad" styleClass="outputText2"  />
                                <h:outputText styleClass="outputText2" value="::"  />
                                <h:panelGroup>
                                <h:inputText styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.cantidad}" id="cantidad" />
                                <h:outputText styleClass="outputText1" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudMantenimientoDetalleMateriales.unidadesMedida.nombreUnidadMedida}"  />
                                </h:panelGroup>

                            </h:panelGrid>
                            <br/>
                                <div align="center">

                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleMateriales.guardarEdicionSolicitudMantenimientoDetalleMateriales_action}"
                                onclick="if(validarEditarSolicitudMantenimientoDetalleMateriales()==false){return false;}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleMateriales')"
                                reRender="dataSolicitudMantenimientoDetalleMateriales" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleMateriales')" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            
            <rich:modalPanel id="panelSolicitudAlmacenDetalleMateriales"  minHeight="400"  minWidth="800"
                                     height="400" width="680"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Solicitud Almacen"/>
                        </f:facet>
                        <a4j:form id="form4">

                        <h:panelGroup id="contenidoSolicitudAlmacenDetalleMateriales">
                            <div align="center">
                                <rich:panel style="width:100%"  headerClass="headerClassACliente">
                                    <f:facet name="header">
                                        <h:outputText value="Registro de Solicitud Salidas a Almacen"  />
                                    </f:facet>
                                    <h:panelGrid columns="4" >

                                        <h:outputText value="Nro Solicitud:" styleClass="outputText2" />
                                        <h:outputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.codFormSalida}" styleClass="outputText2" />

                                        <h:outputText value="Area / Departamento:" styleClass="outputText2" />
                                        <h:outputText styleClass="outputText2" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.areaDestinoSalida.nombreAreaEmpresa}" />
                                        <%--h:selectOneMenu  styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.areaDestinoSalida.codAreaEmpresa}" id="codAreaEmpresa" >
                                            <f:selectItems value="#{ManagedRegistroSolicitudSalidaAlmacen.areasEmpresaList}"  />
                                        </h:selectOneMenu--%>
                                        <h:outputText value="Solicitante:" styleClass="outputText2" />
                                        <h:panelGroup>
                                        <h:outputText styleClass="outputText2" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.solicitante.nombrePersonal}" /> &nbsp;
                                        <h:outputText styleClass="outputText2" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.solicitante.apPaternoPersonal}" /> &nbsp;
                                        <h:outputText styleClass="outputText2" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.solicitante.apMaternoPersonal}" />
                                        </h:panelGroup>



                                        
                                        

                                        <h:outputText value="Orden de Trabajo:" styleClass="outputText2" />
                                        <h:inputText value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.ordenTrabajo}" styleClass="inputText" />

                                        <h:outputText value="Observaciones:" styleClass="outputText2" />
                                        <h:inputTextarea  rows="5" cols="50" styleClass="outputText2" value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalida.obsSolicitud}" />
                                        <h:outputText value="" />
                                        <h:outputText value="" />
                                        
                                    </h:panelGrid>
                                </rich:panel>
                                
                             <rich:dataTable value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesSalidaDetalleList}" var="data"
                                    id="dataSolicitudMantenimientoDetalleMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"  >                                        
                                  
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Material"  />
                                        </f:facet>
                                        <h:outputText value="#{data.materiales.nombreMaterial}"/>
                                    </rich:column>

                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Unid."  />
                                        </f:facet>
                                        <h:outputText value="#{data.materiales.unidadesMedida.nombreUnidadMedida}"   />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:inputText value="#{data.cantidad}"  onkeypress="valNum();" styleClass="inputText" size="5" />
                                    </rich:column>

                                </rich:dataTable>                            
                        </h:panelGroup>
                            <br/>
                                <a4j:commandButton value="Solicitar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleMateriales.registrarSolicitudAlmacen_action}"
                                oncomplete="if(#{ManagedSolicitudMantenimientoDetalleMateriales.mensaje!=''}){alert('#{ManagedSolicitudMantenimientoDetalleMateriales.mensaje}')}else{javascript:Richfaces.hideModalPanel('panelSolicitudAlmacenDetalleMateriales')}"
                                reRender="dataSolicitudMantenimientoDetalleMateriales,botones" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSolicitudAlmacenDetalleMateriales')" />
                                </div>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelSolicitudCompraDetalleMateriales"  minHeight="240"  minWidth="680"
                                     height="240" width="680"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Solicitud Compra"/>
                        </f:facet>
                        <a4j:form id="form5">
                            
                        <div align="center">
                        <h:panelGroup id="contenidoSolicitudCompraDetalleMateriales">
                           
                                <rich:dataTable value="#{ManagedSolicitudMantenimientoDetalleMateriales.solicitudesCompraDetalleList}" var="data"
                                    id="dataSolicitudMantenimientoDetalleMateriales"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"  >

                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Material"  />
                                        </f:facet>
                                        <h:outputText value="#{data.materiales.nombreMaterial}"/>
                                    </rich:column>

                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:inputText value="#{data.cantSolicitada}" styleClass="inputText" onkeypress="valNum();" />
                                    </rich:column>

                                </rich:dataTable>
                        </h:panelGroup>
                            <br/>

                                <a4j:commandButton value="Solicitar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleMateriales.registrarSolicitudCompra_action}"
                                oncomplete="if(#{ManagedSolicitudMantenimientoDetalleMateriales.mensaje!=''}){alert('#{ManagedSolicitudMantenimientoDetalleMateriales.mensaje}');Richfaces.hideModalPanel('panelSolicitudCompraDetalleMateriales')}"
                                reRender="dataSolicitudMantenimientoDetalleMateriales,botones,datosSolicitudMantenimiento" />
                                <a4j:commandButton value="Aceptar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSolicitudCompraDetalleMateriales')" />
                        </div>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

