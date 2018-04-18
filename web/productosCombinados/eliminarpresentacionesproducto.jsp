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
                    <h:panelGrid rendered="#{ManagedBeanProductosCombinados.swEliminaSi}" columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>  
                        <rich:dataTable value="#{ManagedBeanProductosCombinados.presentacionesProductoEli}" var="data" id="dataCliente" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente"
                        >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  />
                        </rich:column>
                         <rich:column>
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
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Peso Neto Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.pesoNetoPresentacion}"  />
                        </rich:column>
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Carton Corrugado"  />
                            </f:facet>
                            <h:outputText value="#{data.cartonesCorrugados.nombreCarton}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lineas MKT"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsPresentacion}"  />
                        </rich:column> 
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        <%--<rich:column id="componentes">
                            <f:facet name="header">
                                <h:outputText value="Componentes"  />
                            </f:facet>
                            <rich:dataTable value="#{data.componentesList}" var="detalle" id="detalle"  
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                            onRowMouseOver="this.style.backgroundColor='#F1F1F1';" 
                                            styleClass="headerClassACliente2"
                            >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Componentes"  />
                                    </f:facet>
                                    <h:outputText value="#{detalle.cantidadCompprod} #{detalle.envasesPrimarios.nombreEnvasePrim} #{detalle.volumenPesoEnvasePrim} #{detalle.coloresPresentacion.nombreColor} #{detalle.saboresProductos.nombreSabor}"  />
                                </rich:column>                                 
                            </rich:dataTable>
                        </rich:column>--%>
                        </rich:dataTable>
                    </h:panelGrid>
                    <br><br>
                    <h:panelGrid rendered="#{ManagedBeanProductosCombinados.swEliminaNo}" columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Estos datos no pueden ser Eliminados " styleClass="outputText2"    />
                        </f:facet>  
                        <rich:dataTable value="#{ManagedBeanProductosCombinados.presentacionesProductoEli2}" var="data" id="dataCliente1" 
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                        headerClass="headerClassACliente"
                        >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  />
                        </rich:column>
                         <rich:column>
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
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Peso Neto Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.pesoNetoPresentacion}"  />
                        </rich:column>
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Carton Corrugado"  />
                            </f:facet>
                            <h:outputText value="#{data.cartonesCorrugados.nombreCarton}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lineas MKT"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsPresentacion}"  />
                        </rich:column> 
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                        <%--<rich:column id="componentes">
                            <f:facet name="header">
                                <h:outputText value="Componentes"  />
                            </f:facet>
                            <rich:dataTable value="#{data.componentesList}" var="detalle" id="detalle"  
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                            onRowMouseOver="this.style.backgroundColor='#F1F1F1';" 
                                            styleClass="headerClassACliente2"
                            >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Componentes"  />
                                    </f:facet>
                                    <h:outputText value="#{detalle.cantidadCompprod} #{detalle.envasesPrimarios.nombreEnvasePrim} #{detalle.volumenPesoEnvasePrim} #{detalle.coloresPresentacion.nombreColor} #{detalle.saboresProductos.nombreSabor}"  />
                                </rich:column>                                 
                            </rich:dataTable>
                        </rich:column>--%>
                        </rich:dataTable>
                    </h:panelGrid>
                    <h:commandButton value="Eliminar" styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.deletePresentacionesProducto}"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.actionCancelar}" />                
                </div>                                
                <!--cerrando la conexion-->
                <%--<h:outputText value="#{tipociente.closeConnection}"  />--%>
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

