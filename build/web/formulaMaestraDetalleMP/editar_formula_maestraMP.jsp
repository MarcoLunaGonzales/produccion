
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script src="../../js/script.js"></script>
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
                function validarCantidades()
                {
                    var tabla=document.getElementById('form1:dataCliente');
                    for(var i=1;i<tabla.rows.length;i++)
                        {

                            if(!(parseInt(tabla.rows[i].cells[1].getElementsByTagName('input')[0].value)>0))
                                {
                                    alert('No puede registrar una cantidad menor o igual a cero en el material '+tabla.rows[i].cells[0].getElementsByTagName('span')[0] .innerHTML)
                                    return false;
                                }

                            if(!(parseInt(tabla.rows[i].cells[3].getElementsByTagName('input')[0].value)>0))
                            {
                                alert('No puede registrar una cantidad de fracciones menor o igual a cero en el material '+tabla.rows[i].cells[0].getElementsByTagName('span')[0] .innerHTML)
                                return false;
                            }
                        }
                        return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                <br>
                <div align="center">
                     <br> <br>
                    <h:outputText value="Editar Materia Prima de:" styleClass="outputText2"   />
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMP.nombreComProd}"   />
                    <br> <br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMPEditarList}" var="data" id="dataCliente" 
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
                            <h:inputText value="#{data.cantidad}" onkeypress="valNum();"/>
                        </h:column>
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Fracciones"  />
                            </f:facet>
                            <h:inputText value="#{data.nroPreparaciones}" onkeypress="valNum();"/>
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                        <h:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.guardarEditarFormulaMaestraDetalleMP}" onclick="return validarCantidades();" />
                        <h:commandButton value="Cancelar"    styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.cancelar}"/>
                    
                    
                </div>
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
            </h:form>
        </body>
    </html>
    
</f:view>

