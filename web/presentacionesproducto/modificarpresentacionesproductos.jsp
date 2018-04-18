
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                
                function validar(nametable){
                   var cantidad=document.getElementById('form:cantidad');                   
                   var producto=document.getElementById('form:producto');
                   var pesoNeto=document.getElementById('form:pesoNeto');
                   var envaseSecundario=document.getElementById('form:envaseSecundario');
                   var tipoMercaderia=document.getElementById('form:tipoMercaderia');
                   var lineaMKT=document.getElementById('form:lineaMKT');
                   var nombrePresentacion=document.getElementById('form:nombrePresentacion');
                       
                   if(producto.value==''){
                         alert('El campo Nombre Comercial está vacio.');
                         producto.focus();
                         return false;
                   }
                   
                   if(cantidad.value==''){
                         alert('El campo Cantidad está vacio.');
                         cantidad.focus();
                         return false;
                   }
                   
                   if(envaseSecundario.value==0){
                         alert('El campo Envase Secundario está vacio.');
                         envaseSecundario.focus();
                         return false;
                   }
                   
                   if(tipoMercaderia.value==0){
                         alert('El campo Tipo de Mercaderia está vacio.');
                         tipoMercaderia.focus();
                         return false;
                   }
                   
                   if(lineaMKT.value==0){
                         alert('El campo Línea está vacio.');
                         lineaMKT.focus();
                         return false;
                   }
                   
                   if(nombrePresentacion.value==''){
                         alert('El campo Nombre de Presentación está vacio.');
                         nombrePresentacion.focus();
                         return false;
                   }

                   
                   var elements=document.getElementById(nametable);
                   
                   var rowsElement=elements.rows;
                   
                   if(rowsElement.length==1){
                        alert("No existe ningún Producto en Proceso asociado a la Presentación.");
                        return false;
                   }

                   return true;
                }

                function recargar(url) {
                    window.location = url;
                }
                function colocarValor_dropdown(){                    
                    document.getElementById('codComponente_dropdown').value=document.getElementById('form:dropdown_componente').value;
                    //alert(document.getElementById('valor_dropdown').value);
                    document.getElementById('nombreComponente_dropdown').value=document.getElementById('form:dropdown_componente')[document.getElementById('form:dropdown_componente').selectedIndex].innerHTML;                    
                }
                function aceptarCambiosComponente(){
                    document.getElementById('codComponente_dropdown').value=document.getElementById('form:dropdown_componente').value;
                    document.getElementById('nombreComponente_dropdown').value=document.getElementById('form:dropdown_componente')[document.getElementById('form:dropdown_componente').selectedIndex].innerHTML;                    
                    document.getElementById('cantidadComponente_dropdown').value=document.getElementById('form:cantidad_componente').value;
                }

                function limpiarComponentesAsociados(){
                    var tablaComponentesAsociados=document.getElementById('form:componentesAsociados');
                    while (tablaComponentesAsociados.firstChild){
                    tablaComponentesAsociados.removeChild(tablaComponentesAsociados.firstChild);
                    }
                }



                 function validarEdicionComponentesSeleccionados(nametable){

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
                    if(count==0){
                        alert('No selecciono ningun Registro');
                        return false;
                    }else{
                     if(count>1){
                        alert('solo se puede editar un Registro');
                        return false;
                    }
                    }
                    return true;
                }

            </script>
        </head>
        <body>               
                <a4j:form id="form">
                    
                    <div align="center">                    
                    <h:outputText value="Editar Presentación de Producto" styleClass="tituloCabezera1"    />

                    <h:panelGroup id="panelEditarPresentacion">
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Presentación de Producto" styleClass="outputText2"   />
                        </f:facet>
                        <h:outputText value="Nombre Comercial" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        
                        <h:selectOneMenu  id="producto" styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.producto.codProducto}"
                                          >
                            <f:selectItems value="#{ManagedPresentacionesProducto.productos}"  />
                            <a4j:support event="onchange"  reRender="componentesAsociados" actionListener="#{ManagedPresentacionesProducto.changeEventProducto}"  />
                        </h:selectOneMenu>
                        
                        <h:outputText value="Tipo Presentacion" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu id="tipoPresentacion" styleClass="inputText"
                        value="#{ManagedPresentacionesProducto.presentacionesProducto.tiposPresentacion.codTipoPresentacion}" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.tiposPresentacion}"  />
                            <a4j:support event="onchange"  reRender="componentesAsociados" actionListener="#{ManagedPresentacionesProducto.changeEventTipoPresentacion}" />
                        </h:selectOneMenu>

                        <h:outputText value="Cantidad de Presentación" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText  styleClass="inputText" id="cantidad" size="10"  onkeypress="valNum();" value="#{ManagedPresentacionesProducto.presentacionesProducto.cantidadPresentacion}" style='text-transform:uppercase;'/>

                        <h:outputText value="Envase Secundario" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.envasesSecundarios.codEnvaseSec}" id="envaseSecundario" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.envasesSecundarios}"  />
                        </h:selectOneMenu>

                        
                        <h:outputText value="Tipo de Mercaderia" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.tiposMercaderia.codTipoMercaderia}" id="tipoMercaderia" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.tiposMercaderia}"  />
                        </h:selectOneMenu>


                        <h:outputText styleClass="outputText2"  value="Línea"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.lineaMKT.codLineaMKT}" id="lineaMKT" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.lineasMKTList}"   />
                        </h:selectOneMenu>
                        
                        
                        <h:outputText styleClass="outputText2"  value="Categoria"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.categoriasProducto.codCategoria}" id="codCategoria" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.categoriaList}"   />
                        </h:selectOneMenu>                        
                        
                        
                        <h:outputText value="Descripción" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedPresentacionesProducto.presentacionesProducto.obsPresentacion}"   />

                        <h:outputText value="Código Alfanumérico" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedPresentacionesProducto.presentacionesProducto.codAnterior}"   />

                        <h:outputText value="Nombre de la Presentación" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputTextarea styleClass="inputText"  cols="50" rows="2" value="#{ManagedPresentacionesProducto.presentacionesProducto.nombreProductoPresentacion}" id="nombrePresentacion" onkeypress="valMAY();"  />

                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.estadoRegistro}"  />
                        </h:selectOneMenu>
                        <h:outputText value="Tipo Programa Produccion" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.tiposProgramaProduccion.codTipoProgramaProd}" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.tiposProgramaProduccionList}"  />
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <br><br>
                        <%--h:panelGroup id="componentesAsociados">
                            <rich:panel styleClass="navegadorTabla" headerClass="headerClassACliente" style="width: 40%">
                            <f:facet name="header" >
                            <h:outputText value="Producto(s) en Proceso Asociados a la Presentación" />
                            </f:facet>
                            <h:outputText value=""/>
                            
                            <rich:dataTable value="#{ManagedPresentacionesProducto.listaComponentesSeleccionados}"
                                var="data"
                                headerClass="headerClassACliente"
                                binding="#{ManagedPresentacionesProducto.componentesSeleccionadosDataTable}"
                                id="componentesSeleccionados">
                                    
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText value=""  />

                                    </f:facet>
                                    <h:selectBooleanCheckbox value="#{data.checked}"  />
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Producto en Proceso"  />
                                    </f:facet>
                                    <h:outputText value="#{data.nombreProdSemiterminado}"  />
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />
                                    </f:facet>
                                    <h:inputText value="#{data.cantidadCompprod}" readonly="true"/>
                                </rich:column>
                            </rich:dataTable>
                            

                            <h:outputText value=""/>                         
                        </rich:panel>
                        </h:panelGroup>
                        
                         <a4j:commandButton value="Agregar" styleClass="boton"
                                               onclick="javascript:Richfaces.showModalPanel('panelAgregarComponente')"
                                               action="#{ManagedPresentacionesProducto.buscarComponentes}" reRender="producto,contenidoAgregarComponente"
                                               status="statusPeticion" />

                        <a4j:commandButton value="Eliminar" styleClass="boton"
                                               action="#{ManagedPresentacionesProducto.eliminaComponentes}" reRender="componentesAsociados"
                                               status="statusPeticion" />
                                               
                        <a4j:commandButton value="Editar" styleClass="boton"
                                               action="#{ManagedPresentacionesProducto.editarComponentes_action}" reRender="contenidoEditarComponente"
                                               status="statusPeticion" onclick="if(validarEdicionComponentesSeleccionados('form:componentesSeleccionados')){Richfaces.showModalPanel('panelEditarComponente')}" /--%>

                        </h:panelGroup>
                    </div>

                                          
                    <input type="hidden" name="codComponente_dropdown"  id="codComponente_dropdown" />
                    <input type="hidden" name="nombreComponente_dropdown"  id="nombreComponente_dropdown" />
                    <input type="hidden" name="cantidadComponente_dropdown"  id="cantidadComponente_dropdown" />
                    
                    

                    <br><br>
                    <div align="center">                        
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedPresentacionesProducto.editPresentacionesProducto}" onclick="return validar('form:componentesSeleccionados')" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedPresentacionesProducto.actionCancelar}" />
                    <h:commandButton value="Ver"  styleClass="commandButton" action="#{ManagedPresentacionesProducto.actionMostrarNombre}" />
                    </div>
            </a4j:form>

                    <rich:modalPanel  minHeight="400" minWidth="600" height="400" width="600" zindex="100" headerClass="headerClassACliente"
                    id="panelAgregarComponente">
                        <a4j:form id="form2">
                        <f:facet name="header">
                            <h:outputText value="Agregar Componente" />
                        </f:facet>
                        <h:panelGroup id="contenidoAgregarComponente">
                        <rich:dataTable  value="#{ManagedPresentacionesProducto.listaComponentesBuscar}"
                                         width="100%"  var="data"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         headerClass="headerClassACliente"
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                         id="componentesAgregar"
                                         rows="10" binding="#{ManagedPresentacionesProducto.componentesBuscarDataTable}">
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value=""/>
                                </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}"/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Producto en Proceso"  />
                                </f:facet>
                                <h:outputText value="#{data.nombreProdSemiterminado} "  />
                            </rich:column>
                            <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />
                                    </f:facet>
                                    <h:inputText styleClass="inputText" value="#{data.cantidadCompprod}"/>
                             </rich:column>
                        </rich:dataTable>
                        <rich:datascroller align="center" for="componentesAgregar" maxPages="20" id="scComponentesAgregar" ajaxSingle="false" />
                        <div align="center">
                        <%--<h:commandButton value="Aceptar" styleClass="boton"  action="#{ManagedPresentacionesProducto.cargarComponentes}"/>--%>
                        <a4j:commandButton value="Aceptar" styleClass="boton" onclick="javascript:Richfaces.hideModalPanel('panelAgregarComponente')"
                        action="#{ManagedPresentacionesProducto.cargarComponentes}" ajaxSingle="false" reRender="componentesAsociados,componentesSeleccionados" />
                        <a4j:commandButton value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarComponente')"/>
                        </div>
                        </h:panelGroup>

                        </a4j:form>
                      </rich:modalPanel>


                      <rich:modalPanel  minHeight="400"
                    minWidth="600" height="400" width="600" zindex="100" headerClass="headerClassACliente"
                    id="panelEditarComponente">
                        <f:facet name="header">
                            <h:outputText value="Editar Componente"/>
                        </f:facet>

                        <a4j:form>
                                <h:panelGroup id="contenidoEditarComponente" >
                                    <h:panelGrid columns="2">
                        <h:outputText styleClass="outputText2"  value="Nombre Componente"/>


                        <h:selectOneMenu styleClass="inputText"  value="#{ManagedPresentacionesProducto.editarComponente.codCompprod}" id="dropdown_componente" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.componenteEditarList}" />
                        </h:selectOneMenu>

                        <h:outputText styleClass="outputText2"  value="Cantidad" />
                        <h:inputText  styleClass="inputText" size="10"  value="#{ManagedPresentacionesProducto.editarComponente.cantidadCompprod}" id="cantidad_componente" />

                        <a4j:commandButton  value="Aceptar" styleClass="boton" onclick="Richfaces.hideModalPanel('panelEditarComponente')"
                        action="#{ManagedPresentacionesProducto.aceptarEdicionComponente_action}" ajaxSingle="false"
                        status="statusPeticion" reRender="componentesAsociados,form"
                        />

                        <a4j:commandButton value="Cancelar" styleClass="boton"  onclick="javascript:Richfaces.hideModalPanel('panelEditarComponente')"
                        action="#{ManagedPresentacionesProducto.cancelarEdicion_action}"
                        status="statusPeticion"/>


                        </h:panelGrid>
                        </h:panelGroup>
                        </a4j:form>

                    </rich:modalPanel>


        </body>
    </html>

</f:view>