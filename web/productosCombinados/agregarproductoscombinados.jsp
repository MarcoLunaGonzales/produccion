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
                function validar(){
                   var cantidad=document.getElementById('form1:cantidad');
                       pesoNeto=document.getElementById('form1:pesoNeto');
                                         
                   if(cantidad.value==''){
                         alert('El campo Cantidad esta vacio.');
                         cantidad.focus();
                           return false;
                   }
                                                    
                   return true;
                }
                  function visibilityPanel(){
                        document.getElementById('form1:panelBuscar').style.visibility='hidden';
                        document.getElementById('panelsuper').style.visibility='hidden';
                        document.getElementById('form1:panelBuscar1').style.visibility='hidden';
                        
                 }
            </script>
        </head>
        <body onload="visibilityPanel();carga();">            
            <a4j:form id="form1"  >                
                <div align="center">
                    <!--buscar componentes-->
                    <rich:panel id="panelBuscar" styleClass="panelBuscar" 
                                style="top:100px;left:150px;"
                    >
                        <f:facet name="header">
                            <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"closePanelBuscar();\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "  
                                          escape="false" />
                        </f:facet>
                        <h:panelGrid columns="4" headerClass="headerClassACliente" width="50%">
                            <f:facet name="header">
                                <h:outputText value="Componetes"  styleClass="tituloCampo"/>                        
                            </f:facet>                    
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.producto.codProducto}"                            
                                             valueChangeListener="#{ManagedBeanProductosCombinados.changeEventProductos}" id="codCompProd" >
                                <f:selectItems value="#{ManagedBeanProductosCombinados.componentes1Lista}"  />
                                <a4j:support event="onchange"  reRender="resultadoBuscarComponente"  />
                            </h:selectOneMenu>                            
                        </h:panelGrid>
                        <rich:dataTable  value="#{ManagedBeanProductosCombinados.listaComponentesBuscar}"  
                                         width="100%"  var="data" style="width:50%" 
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';" id="resultadoBuscarComponente" >
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value=""  />
                                    
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Componentes"  />
                                </f:facet>
                                <h:outputText value="#{data.cantidadCompprod} #{data.envasesPrimarios.nombreEnvasePrim} #{data.volumenPesoEnvasePrim} #{data.coloresPresentacion.nombreColor} #{data.saboresProductos.nombreSabor}"  />
                            </rich:column> 
                        </rich:dataTable>
                        <h:commandButton value="Aceptar" styleClass="boton"  action="#{ManagedBeanProductosCombinados.cargarComponentes}"/>                        
                    </rich:panel>    
                    
                    <!--buscar MATERIAL PROMOCIONAL-->
                    <rich:panel id="panelBuscar1" styleClass="panelBuscar" 
                                style="top:100px;left:150px;"
                    >
                        <f:facet name="header">
                            <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar1');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"closePanelBuscar1();\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "  
                                          escape="false" />
                        </f:facet>
                        <h:panelGrid columns="2" headerClass="headerClassACliente" width="50%">
                            <f:facet name="header">
                                <h:outputText value="Introduzca el nombre del producto a Buscar"  styleClass="tituloCampo"/>
                            </f:facet>
                            <h:inputText  value="#{ManagedBeanProductosCombinados.buscarDato}" onkeypress="valMAY();" styleClass="inputText" size="50" id="productobuscar"  >
                                <%--<a4j:support  event="onkeyup"  reRender="resultadoBuscarProducto"  />--%>
                            </h:inputText>
                            <f:facet name="header">
                                <h:outputText value=""  styleClass="tituloCampo"/>
                            </f:facet>
                            <a4j:commandButton value="Buscar" styleClass="commandButton" actionListener="#{ManagedBeanProductosCombinados.buscarDatos}"  reRender="resultadoBuscarMaterialPromocional" />
                        </h:panelGrid>
                        <rich:dataTable  value="#{ManagedBeanProductosCombinados.productoList}"  
                                         width="100%"  var="data" style="width:50%" 
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';" id="resultadoBuscarMaterialPromocional" >
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Material Promocional"  />
                                </f:facet>
                                <a4j:commandLink onclick="document.getElementById('form1:panelBuscar1').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';"  
                                                 actionListener="#{ManagedBeanProductosCombinados.cogerCodigo}"   reRender="detalleMaterialPromocional">
                                    <h:outputText value="#{data.nombre_matpromocional} " style="width=100%" />                                    
                                </a4j:commandLink>
                            </rich:column> 
                        </rich:dataTable>                        
                    </rich:panel>    
                    <h3>Registrar Producto Combinado</h3>
                    <h:panelGrid columns="4" styleClass="navegadorTabla" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="" styleClass="outputText2"   />
                        </f:facet>
                        <h:outputText value="Nombre" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedBeanProductosCombinados.presentacionesProducto.nombreProductoPresentacion}" onkeypress="valMAY();" id="nombreProducto"  />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Cantidad de Presentación" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText  styleClass="inputText" id="cantidad" size="50"  onkeypress="valNum();" value="#{ManagedBeanProductosCombinados.presentacionesProducto.cantidadPresentacion}" style='text-transform:uppercase;'/>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Envase Secundario" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.envasesSecundarios.codEnvaseSec}" >
                            <f:selectItems value="#{ManagedBeanProductosCombinados.envasesSecundarios}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Envase Terciario" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.envasesTerciarios.codEnvaseTerciario}" >
                            <f:selectItems value="#{ManagedBeanProductosCombinados.envasesTerciarios}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Tipo de Mercaderia" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.tiposMercaderia.codTipoMercaderia}" >
                            <f:selectItems value="#{ManagedBeanProductosCombinados.tiposMercaderia}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Peso Neto Presentación" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText  styleClass="inputText" id="pesoNeto" size="50"  onkeypress="valNum();" value="#{ManagedBeanProductosCombinados.presentacionesProducto.pesoNetoPresentacion}" style='text-transform:uppercase;'/>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Carton Corrugado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu   styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.cartonesCorrugados.codCaton}" >
                            <f:selectItems value="#{ManagedBeanProductosCombinados.cartonesCorrugados}"  />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText styleClass="outputText2"  value="Linea MKT"  />                        
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedBeanProductosCombinados.presentacionesProducto.lineaMKT.codLineaMKT}" >
                            <f:selectItems value="#{ManagedBeanProductosCombinados.lineasMKTList}"   />
                        </h:selectOneMenu>
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Descripción" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedBeanProductosCombinados.presentacionesProducto.obsPresentacion}"   />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Código Anterior" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        <h:inputText styleClass="inputText"  size="50" value="#{ManagedBeanProductosCombinados.presentacionesProducto.codAnterior}"   />
                        <h:outputText styleClass="outputText2" value=""  />                        
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value=""  />
                        <h:inputText    styleClass="inputText" size="50" disabled="true" value="ACTIVO"/>                                
                        <h:outputText styleClass="outputText2" value=""  />                        
                    </h:panelGrid>
                    <%--------------------------- COMPONENTES ----------------------%>
                    <rich:panel  style="width:61%">
                        <f:facet name="header">
                            <h:outputText value="Componentes"  />
                        </f:facet>                       
                        
                        <h:panelGrid columns="1" style="width:100%">                            
                            <rich:dataTable value="#{ManagedBeanProductosCombinados.listaComponentesSeleccionados}" var="data" id="detalle" width="100%">
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText value=""  />                                        
                                    </f:facet>
                                    <h:selectBooleanCheckbox value="#{data.checked}"  />
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Producto"  />
                                    </f:facet>
                                    <h:outputText value="#{data.producto.nombreProducto}"  />
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Componente"  />
                                    </f:facet>
                                    <h:outputText value="#{data.cantidadCompprod} #{data.envasesPrimarios.nombreEnvasePrim} #{data.volumenPesoEnvasePrim} #{data.coloresPresentacion.nombreColor} #{data.saboresProductos.nombreSabor}"  />
                                </rich:column>
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />                                        
                                    </f:facet>
                                    <h:inputText value="#{data.cantidadComponente}" styleClass="inputText" />
                                </rich:column>                                
                            </rich:dataTable>                            
                        </h:panelGrid>  
                        <h:panelGroup style="tex-align:left;">
                            <a4j:commandButton value="Agregar" styleClass="boton"  
                                               onclick="document.getElementById('form1:panelBuscar').style.visibility='visible';" 
                                               action="#{ManagedBeanProductosCombinados.buscarComponentes}" reRender="codCompProd,codMaterialPromocional"  >                               
                            </a4j:commandButton>                           
                            <a4j:commandButton value="Eliminar" styleClass="boton"  
                                               action="#{ManagedBeanProductosCombinados.eliminaComponentes}" reRender="detalle"  >                                
                            </a4j:commandButton>
                        </h:panelGroup>
                    </rich:panel>
                    <%--------------------------- MATERIAL PROMOCIONAL ----------------------%>
                    <rich:panel  style="width:61%">
                        <f:facet name="header">
                            <h:outputText value="Material Promocional"  />
                        </f:facet>                                               
                        <h:panelGrid columns="1" style="width:100%">                            
                            <rich:dataTable value="#{ManagedBeanProductosCombinados.componentes2Lista}" var="data" id="detalleMaterialPromocional" width="100%">                                
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText value=""  />
                                    </f:facet>
                                    <a4j:commandLink data="#{data.codTemp}"
                                                     onclick="document.getElementById('form1:panelBuscar1').style.visibility='visible';" actionListener="#{ManagedBeanProductosCombinados.cogerId}" accesskey="b">
                                        <h:graphicImage url="../img/lupa.png"  style="border:0px solid red;" />                            
                                    </a4j:commandLink>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Nombre"  />
                                    </f:facet>
                                    <h:outputText value="#{data.nombreMatPromocional}" />
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />
                                    </f:facet>
                                    <h:inputText value="#{data.cantidadMatPromocional}" styleClass="inputText" />
                                </rich:column>
                            </rich:dataTable>                            
                        </h:panelGrid>  
                        <h:panelGroup style="tex-align:left;">
                            <a4j:commandButton value="Agregar" styleClass="boton" action="#{ManagedBeanProductosCombinados.masActionMaterialPromocional}" onclick="document.getElementById('form1:panelBuscar1').style.visibility='visible';"   >
                            </a4j:commandButton>                           
                            <a4j:commandButton value="Eliminar" styleClass="boton"  
                                               action="#{ManagedBeanProductosCombinados.menosActionMaterialPromocioal}" reRender="detalleMaterialPromocional"  >                                
                            </a4j:commandButton>
                        </h:panelGroup>
                    </rich:panel>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.savePresentacionesProducto}" onclick="return validar()" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedBeanProductosCombinados.actionCancelar}" />
                </div>                
            </a4j:form>
            <h:panelGroup   id="panelsuper"  styleClass="panelSuper" >
            </h:panelGroup>
        </body>
    </html>
    
</f:view>

