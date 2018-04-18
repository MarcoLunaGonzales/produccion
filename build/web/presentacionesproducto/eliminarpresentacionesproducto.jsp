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
        </head>
        <body>
            <h:form id="form1"  >                
                <div align="center">                    
                    <h:outputText value="Eliminar Presentación(es) de Producto" styleClass="tituloCabezera1"    />
                    
                    <h:panelGrid rendered="#{ManagedPresentacionesProducto.swEliminaSi}" columns="3" styleClass="panelgrid" >
                         <f:facet name="header" >
                            <h:outputText value="Estos Datos Pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>  
                        <rich:dataTable value="#{ManagedPresentacionesProducto.presentacionesProductoEli}" var="data" id="dataCliente" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente"
                        >
                           <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código"  />
                            </f:facet>
                            <h:outputText value="#{data.codPresentacion}" id="codPresentacion" />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  id="nombreProductoPresentacion" />
                        </rich:column>
 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column>
                         <%--rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad de Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadPresentacion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesSecundarios.nombreEnvaseSec}"  />
                        </rich:column>  
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Terciario"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesTerciarios.nombreEnvaseTerciario}"  />
                        </rich:column--%>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cant. Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.cantEnvaseSecundario}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Línea"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código Alfanumérico"  />
                            </f:facet>
                            <h:outputText value="#{data.codAnterior}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        </rich:dataTable>
                    </h:panelGrid>
                    <br><br>
                    <h:panelGrid rendered="#{ManagedPresentacionesProducto.swEliminaNo}" columns="3" styleClass="panelgrid" >
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>  
                        <rich:dataTable value="#{ManagedPresentacionesProducto.presentacionesProductoEli2}" var="data" id="dataCliente1" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente"
                        >
                            <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código"  />
                            </f:facet>
                            <h:outputText value="#{data.codPresentacion}" id="codPresentacion" />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Presentación"/>
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  id="nombreProductoPresentacion" />
                        </rich:column>
 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column>
                         <%--rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad de Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadPresentacion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesSecundarios.nombreEnvaseSec}"  />
                        </rich:column>  
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Envase Terciario"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesTerciarios.nombreEnvaseTerciario}"  />
                        </rich:column--%>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cant. Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.cantEnvaseSecundario}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Línea"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código Alfanumérico"  />
                            </f:facet>
                            <h:outputText value="#{data.codAnterior}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>          
                        </rich:dataTable>
                    </h:panelGrid>
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedPresentacionesProducto.deletePresentacionesProducto}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorpresentacionesproducto" />                
                </div>                                
                <!--cerrando la conexion-->
                <%--<h:outputText value="#{tipociente.closeConnection}"  />--%>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

