<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            
            
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function validar(nametable){
                   var cantidad=document.getElementById('form1:cantidad');
                       producto=document.getElementById('form1:producto');
                       pesoNeto=document.getElementById('form1:pesoNeto');
                       envaseSecundario=document.getElementById('form1:envaseSecundario');
                       tipoMercaderia=document.getElementById('form1:tipoMercaderia');
                       lineaMKT=document.getElementById('form1:lineaMKT');
                       nombrePresentacion=document.getElementById('form1:nombrePresentacion');
                       
                   if(producto.value==0){
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

                
                
                function visibilityPanel(){
                        document.getElementById('form1:panelBuscar').style.visibility='hidden';
                        document.getElementById('panelsuper').style.visibility='hidden';
                        
                 }
                 
                 function cargarDatos(){
                    var producto=document.getElementById("form1:producto");
                    var nombrePresentacion=document.getElementById("form1:nombrePresentacion");
                    var envaseTerciario=document.getElementById("form1:envaseTerciario");
                    var cantidad=document.getElementById("form1:cantidad");
                    
                    nombrePresentacion.value=producto.options[producto.selectedIndex].text+" "+envaseTerciario.options[envaseTerciario.selectedIndex].text+" x "+cantidad.value;
                 }
            </script>
        </head>
        <body onload="visibilityPanel()">
            <br><br>
            <a4j:form id="form1"  >
                
                <div align="center">
                    <!--buscar componentes-->
                    <rich:panel id="panelBuscar" styleClass="panelBuscar" 
                                style="top:100px;left:150px;" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"closePanelBuscar();\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "  
                                          escape="false" />
                        </f:facet>
                        
                        <rich:dataTable  value="#{ManagedPresentacionesProducto.listaComponentesBuscar}"  
                                         width="100%"  var="data" style="width:50%" 
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                         headerClass="headerClassACliente"
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';" id="resultadoBuscarComponente" >
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
                                <%--h:outputText value="#{data.forma.nombreForma} #{data.envasesPrimarios.nombreEnvasePrim} #{data.volumenPesoEnvasePrim} #{data.coloresPresentacion.nombreColor} #{data.saboresProductos.nombreSabor}"  /--%>
                                <h:outputText value="#{data.nombreProdSemiterminado} "  />
                            </rich:column>
                            <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />
                                    </f:facet>
                                    <h:inputText styleClass="inputText" value="#{data.cantidadCompprod}"/>
                             </rich:column>
                        </rich:dataTable>
                        <h:commandButton value="Aceptar" styleClass="boton"  action="#{ManagedPresentacionesProducto.cargarComponentes}"/>
                        
                    </rich:panel>                        
                    <!--buscar componentes-->
                    
                    <!--CUERPO PRINCIPAL DE REGISTRAR-->
                    
                    <h:outputText value="Editar Presentación de Producto" styleClass="tituloCabezera1"    />
                    
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Presentación de Producto" styleClass="outputText2"   />
                        </f:facet>
                        <h:outputText value="Nombre Comercial" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        <h:selectOneMenu  id="producto" styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.producto.codProducto}" 
                                          valueChangeListener="#{ManagedPresentacionesProducto.changeEventProducto}">
                            <f:selectItems value="#{ManagedPresentacionesProducto.productos}"  />
                            <a4j:support event="onchange"  reRender="detalle"  />
                        </h:selectOneMenu>
                        

                        <h:outputText value="Tipo Presentacion" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu id="tipoPresentacion" styleClass="inputText"
                        value="#{ManagedPresentacionesProducto.presentacionesProducto.codTipoPresentacion}"
                        valueChangeListener="#{ManagedPresentacionesProducto.changeEventTipoPresentacion}">
                            <f:selectItems value="#{ManagedPresentacionesProducto.tiposPresentacion}"  />
                                          <a4j:support event="onchange"  reRender="detalle" />
                        </h:selectOneMenu>                        
                        

                        
                        <h:outputText value="Cantidad de Presentación" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText  styleClass="inputText" id="cantidad" size="10"  onkeypress="valNum();" value="#{ManagedPresentacionesProducto.presentacionesProducto.cantidadPresentacion}" style='text-transform:uppercase;'/>
                        
                        <h:outputText value="Envase Secundario" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.envasesSecundarios.codEnvaseSec}" id="envaseSecundario" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.envasesSecundarios}"  />
                        </h:selectOneMenu>
                        
                        <%--h:outputText value="Cant. Envase Secundario" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText  styleClass="inputText" id="pesoNeto" size="50"  onkeypress="valNum();" value="#{ManagedPresentacionesProducto.presentacionesProducto.cantEnvaseSecundario}" style='text-transform:uppercase;'/>
                        
                        
                        <h:outputText value="Envase Terciario" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.envasesTerciarios.codEnvaseTerciario}" id="envaseTerciario" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.envasesTerciarios}"  />
                        </h:selectOneMenu--%>
                        
                        <h:outputText value="Tipo de Mercaderia" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.tiposMercaderia.codTipoMercaderia}" id="tipoMercaderia" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.tiposMercaderia}"  />
                        </h:selectOneMenu>
                        
                        
                        <%--h:outputText value="Formato de Cartón Corrugado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu   styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.cartonesCorrugados.codCaton}" id="cartonCorrugado" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.cartonesCorrugados}"  />
                        </h:selectOneMenu--%>
                        
                        <h:outputText styleClass="outputText2"  value="Línea"  />                        
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProducto.lineaMKT.codLineaMKT}" id="lineaMKT" >
                            <f:selectItems value="#{ManagedPresentacionesProducto.lineasMKTList}"   />
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

                        
                    </h:panelGrid>


                    <h:panelGroup id="panelContenido">
                    <rich:panel  style="width:61%" headerClass="headerClassACliente" id="componentesSeleccionados">
                        <f:facet name="header">
                            <h:outputText value="Producto(s) en Proceso Asociados a la Presentación" />
                        </f:facet>
                        
                        <h:panelGrid columns="1">                            
                            <rich:dataTable value="#{ManagedPresentacionesProducto.listaComponentesSeleccionados}" var="data" id="detalle" headerClass="headerClassACliente"
                            binding="#{ManagedPresentacionesProducto.componentesSeleccionadosDataTable}">
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
                                    <h:inputText styleClass="inputText" value="#{data.cantidadCompprod}" readonly="true" />
                                </rich:column>
                            </rich:dataTable>                            
                        </h:panelGrid>
                        
                        <h:panelGroup style="tex-align:left;background-color:#ffffff;">
                            <a4j:commandButton value="Agregar" styleClass="boton"  
                                               onclick="document.getElementById('form1:panelBuscar').style.visibility='visible';" 
                                               action="#{ManagedPresentacionesProducto.buscarComponentes}" reRender="producto,resultadoBuscarComponente"
                                               status="statusPeticion" >
                            </a4j:commandButton>                           
                            <a4j:commandButton value="Eliminar" styleClass="boton"  
                                               action="#{ManagedPresentacionesProducto.eliminaComponentes}" reRender="detalle"
                                               status="statusPeticion" >
                            </a4j:commandButton>
                            <a4j:commandButton value="Editar" action="#{ManagedPresentacionesProducto.editarComponente_action}" 
                                                styleClass="boton"
                                                onclick="javascript:Richfaces.showModalPanel('panelComponenteSeleccionado')"
                                                reRender="panelEditarComponente" status="statusPeticion" />
                        </h:panelGroup>
                    </rich:panel>
                    </h:panelGroup>

                    <%--panel de modificacion de componente--%>
                    
                    <rich:modalPanel  minHeight="400"
                    minWidth="600" height="400" width="600" zindex="100" headerClass="headerClassACliente"
                    id="panelComponenteSeleccionado">
                        <f:facet name="header">
                            <h:outputText value="Componente Seleccionado" />
                        </f:facet>
                        <h:panelGroup id="panelEditarComponente" >
                            <h:panelGrid columns="2">
                        
                        
                        <h:outputText styleClass="outputText2"  value="Nombre Componente"/>
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.editarCodCompprod}">
                            <f:selectItems value="#{ManagedPresentacionesProducto.componenteEditarList}"  />
                        </h:selectOneMenu>                        
                        <h:outputText styleClass="outputText2"  value="Cantidad"/>
                        <h:inputText  styleClass="inputText" size="10"  onkeypress="valNum();" value="#{ManagedPresentacionesProducto.editarCantidadCompprod}" />
                        <a4j:commandButton  value="Aceptar" styleClass="boton" oncomplete="javascript:Richfaces.hideModalPanel('panelComponenteSeleccionado')"
                        action="#{ManagedPresentacionesProducto.aceptarEdicionComponente_action}" status="statusPeticion"
                        reRender="componentesSeleccionados"/>
                        
                        <a4j:commandButton value="Cancelar" styleClass="boton"  onclick="javascript:Richfaces.hideModalPanel('panelComponenteSeleccionado')"  action="#{ManagedPresentacionesProducto.cancelarEdicion_action}"
                        status="statusPeticion"/>
                        
                        </h:panelGrid>
                        </h:panelGroup>
                    </rich:modalPanel>

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
                    
                    <br>
                        
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedPresentacionesProducto.editPresentacionesProducto}" onclick="return validar('form1:detalle')" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedPresentacionesProducto.actionCancelar}" />
                    <h:commandButton value="Ver"  styleClass="commandButton" action="#{ManagedPresentacionesProducto.actionMostrarNombre}" />
                </div>             
                
            </a4j:form>            
          
        </body>
    </html>
    
</f:view>

