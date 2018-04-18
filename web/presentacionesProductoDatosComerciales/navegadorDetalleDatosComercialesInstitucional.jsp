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
            <script type="text/javascript" src='../js/general.js' ></script> 
        </head>
        <body >
            <h:form id="form1"  >                
                <div align="center">
                    <%--<h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.obtenerCodigo}"   />--%>
                    <h:outputText styleClass="tituloCabezera1" value="DETALLE DE PRECIOS INSTITUCIONALES DE PRODUCTOS" />
                    <rich:panel headerClass="headerClassACliente" style="width:50%">
                        <f:facet name="header">
                            <h:outputText value="Producto de Venta"  />
                        </f:facet>
                        <h:outputText styleClass="outputTextNormal" value="#{ManagedPresentacionesProductoDatosComerciales.nombreproducto}" />
                    </rich:panel>
                    <br/>
                    
                    
                    <rich:dataTable  value="#{ManagedPresentacionesProductoDatosComerciales.presentacionesProductoDetalleList}"  
                                     width="100%"  var="data" style="width:50%" 
                                     columnClasses="tituloCampo"
                                     headerClass="headerClassACliente"
                                     onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                     headerClass="headerClassACliente"
                                     id="resultadoBuscarComponente" >
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha de Registro"  />
                            </f:facet>
                            <h:outputText   value="#{data.fechaRegistro}"  /> 
                        </rich:column>                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Precio Institucional"  />
                            </f:facet>
                            <h:outputText  value="#{data.precioInstitucional}"  /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Precio Institucional 2"  />
                            </f:facet>
                            <h:outputText  value="#{data.precioInstitucional2}"  /> 
                        </rich:column>                         
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreEstadoREgistro}"  /> 
                        </rich:column>
                    </rich:dataTable>
                                        
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedPresentacionesProductoDatosComerciales.actionEditPresentacionesProductoDatosComercialesInstitucional}" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="#{ManagedPresentacionesProductoDatosComerciales.CancelarInstitucional}"  onclick="location='navegadorPresentacionesProductoBuscar.jsf'"/>
                    
                </div>                               
                <!--cerrando la conexion-->
              
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

