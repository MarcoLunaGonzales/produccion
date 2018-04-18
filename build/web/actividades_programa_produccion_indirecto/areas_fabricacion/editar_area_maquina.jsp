<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script>
                function validar(){
                   var nombreareaempresa=document.getElementById('form1:nombreareaempresa');
                   var obsareaempresa=document.getElementById('form1:obsareaempresa');
                   if(nombreareaempresa.value==''){
                     alert('Por favor instroduzca Nombre Area Empresa');
                     nombreareaempresa.focus();
                     return false;
                   }
                   /*if(obsareaempresa.value==''){
                     alert('Por favor instroduzca datos');
                     obsareaempresa.focus();
                     return false;
                   } */                  
                   return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                
                <br>
                
                <div align="center">
                    <h:outputText value="Editar Areas Dependientes a:#{areasdependientes.nombreAreaEmpresa}" styleClass="outputText2"   />
                    
                    <br> <br>
                    <rich:dataTable value="#{areasdependientes.areasDependientesEditarList}" var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Areas Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreAreaDependiente}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nro Orden"  />
                            </f:facet>
                            <h:inputText  styleClass="inputText" value="#{data.nroOrden}" id="nro_orden" size="10" onclick="valNum();"/>
                        </h:column>
                    </rich:dataTable>
                    <br>
                    <h:commandButton value="Guardar"   styleClass="btn"  action="#{areasdependientes.guardarEditarAreasDependientes}"/>
                    <h:commandButton value="Cancelar"    styleClass="btn"  action="navegadorAreasDependientes"/>
                   

                </div>
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
            </h:form>
        </body>
    </html>
    
</f:view>

