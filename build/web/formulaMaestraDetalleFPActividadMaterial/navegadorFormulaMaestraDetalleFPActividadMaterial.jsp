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
        function validarIngresoFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form2:codMaterial").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
        function validarEdicionFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form3:codMaterial").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.cargarContenidoFormulaMaestraDetalleFPActividadMaterial}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Materiales de Actividad" />
                    <br><br>

                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterialList}" var="data"
                                    id="dataFormulaMaestraFPActividadMaterial"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >


                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="1ra Temperatura"  />
                            </f:facet>
                            <h:outputText value="#{data.temperatura1}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="2da Temperatura"  />
                            </f:facet>
                            <h:outputText value="#{data.temperatura2}" />
                        </h:column>
                        
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>                    
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaterial')"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.agregarFormulaMaestraDetalleFPActividadMaterial_action}"
                    reRender="contenidoAgregarFormulaMaestraDetalleFPActividad" />
                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataFormulaMaestraFPActividadMaterial')==false){return false;}else{Richfaces.showModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaterial')}"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.editarFormulaMaestraDetalleFPActividad_action}"
                    reRender="contenidoEditarFormulaMaestraDetalleFPActividad" />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataFormulaMaestraFPActividadMaterial')==false){return false;}"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.eliminarFormulaMaestraDetalleFPActividadMaterial_action}"
                    reRender="dataFormulaMaestraFPActividadMaterial"/>

                    <a4j:commandButton styleClass="btn" value="Cancelar" onclick="location='../formulaMaestraDetalleFPActividad/navegadorFormulaMaestraDetalleFPActividad.jsf'" />
                    

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />
                
            </a4j:form>



             <rich:modalPanel id="panelAgregarFormulaMaestraDetalleFPActividadMaterial" minHeight="150"  minWidth="400"
                                     height="200" width="310"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Actividad Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoAgregarFormulaMaestraDetalleFPActividad">
                            <h:panelGrid columns="3">
                                <h:outputText value="Material" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.materiales.codMaterial}" id="codMaterial">
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.materialesList}" />
                                    <a4j:support event="onchange" action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.material_change}" reRender="unidades" />
                                </h:selectOneMenu>
                                
                                <h:outputText value="Cantidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.cantidad}" styleClass="inputText"/>
                                
                                <h:outputText value="Unidades" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:outputText id="unidades"   value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.materiales.unidadesMedida.nombreUnidadMedida}" styleClass="outputText1"/>

                                <h:outputText value="1ra Temperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.temperatura1}" styleClass="inputText"/>
                                
                                <h:outputText value="2da Temperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.temperatura2}" styleClass="inputText"/>




                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" 
                                onclick="if(validarIngresoFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaterial');}"
                                action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.registrarFormulaMaestraDetalleFPActividadMaterial_action}" reRender="dataFormulaMaestraFPActividadMaterial"
                                                    />                                
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaterial')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarFormulaMaestraDetalleFPActividadMaterial" minHeight="150"  minWidth="400"
                                     height="200" width="310"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarFormulaMaestraDetalleFPActividad">
                            <h:panelGrid columns="3">
                                 <h:outputText value="Material" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.materiales.codMaterial}" id="codMaterial">
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.materialesList}" />
                                    <a4j:support event="onchange" action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.material_change}" reRender="unidadesEditar" />
                                </h:selectOneMenu>

                                <h:outputText value="Cantidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.cantidad}" styleClass="inputText"/>

                                <h:outputText value="Unidades" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:outputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.materiales.unidadesMedida.nombreUnidadMedida}" styleClass="outputText1" id="unidadesEditar"/>


                                <h:outputText value="1ra Temperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.temperatura1}" styleClass="inputText"/>

                                <h:outputText value="2da Temperatura" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaterial.formulaMaestraDetalleFPActividadMaterial.temperatura2}" styleClass="inputText"/>



                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" 
                                onclick="if(validarEdicionFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaterial');}"
                                
                                action="#{ManagedFormulaMaestraDetalleFPActividadMaterial.guardarEdicionFormulaMaestraFPActividad_action}" reRender="dataFormulaMaestraFPActividadMaterial"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaterial')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

