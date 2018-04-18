package formullaMaestraVersiones.formulaMaestraDetalleEP;

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
               
                <div align="center" class="outputText2">
                    Estos Datos Serán Eliminados
                  <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleEP.formulaMaestraDetalleEPEliminarList}" var="data" id="dataAreasDependientes" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
            
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                    
                        
                    </rich:dataTable>
                    <br>
                    <h:commandButton value="Eliminar" styleClass="btn" action="#{ManagedFormulaMaestraDetalleEP.guardarEliminarFormulaMaestraDetalleEP}" />
                    <h:commandButton value="Cancelar"  styleClass="btn"  action="cancelarAreasEmpresa" />                </div>
                
                
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

