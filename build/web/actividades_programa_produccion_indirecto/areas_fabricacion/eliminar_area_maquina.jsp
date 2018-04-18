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
                    <rich:dataTable value="#{areas_empresa.areasempresaeliminar}" var="data" 
                    id="dataCliente"  onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" headerClass="headerClassACliente">
>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Codigo"  />
                                
                            </f:facet>
                            <h:outputText value="#{data.codAreaEmpresa}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreAreaEmpresa}"  />
                        </h:column>
                
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsAreaEmpresa}"  />
                        </h:column>
                    </rich:dataTable>
                    
                    <h:commandButton value="Eliminar" styleClass="btn" action="#{areas_empresa.eliminarAreasEmpresa}" />
                    <h:commandButton value="Cancelar"  styleClass="btn"  action="cancelarAreasEmpresa" />                </div>
                
                
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

