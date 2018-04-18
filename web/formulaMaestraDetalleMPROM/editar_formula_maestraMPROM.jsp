
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
                     <br> <br>
                    <h:outputText value="Editar Material Promocional a:" styleClass="outputText2"   />
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMPROM.nombreComProd}"   />
                    <br> <br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMPROM.formulaMaestraDetalleMPROMEditarList}" var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Material Promocional"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onkeypress="valNum();"/>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                    </rich:dataTable>
                    <br>
                    <h:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMPROM.guardarEditarFormulaMaestraDetalleMPROM}"/>
                    <h:commandButton value="Cancelar"    styleClass=""  action="#{ManagedFormulaMaestraDetalleMPROM.cancelar}"/>
                    
                    
                </div>
                
              </h:form>
        </body>
    </html>
    
</f:view>

