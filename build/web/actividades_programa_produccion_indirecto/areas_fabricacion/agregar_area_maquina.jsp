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
            function AdicionarItems(nametable){
        
                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                }
            /*var cantidadadicionar=document.getElementById('cantidadadicionar');
            cantidadadicionar.value=count;*/
            return true;
           }
                                            </script>
        </head>
        <body>
            <h:form id="form1"  >
                
                <div align="center">
                    
                    <h:outputText value="Adicionar Maquinaria a:#{ManagedAreasMaquina.nombreAreaFabricacion}" styleClass="outputText2"   />
                    <br><br>
                    <rich:dataTable value="#{ManagedAreasMaquina.areasMaquinaAdicionarList}" var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Código"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.codigo}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}"  />
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedAreasMaquina.guardarAreasMaquina}"   onclick="return AdicionarItems('form1:dataCliente');" />
                    <h:commandButton value="Cancelar" styleClass="btn" action="#{ManagedAreasMaquina.cancelar}"/>
                    
                </div>
                
            </h:form>
        </body>
    </html>
    
</f:view>

