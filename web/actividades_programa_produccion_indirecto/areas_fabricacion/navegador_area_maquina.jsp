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
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
           function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }            
                                            </script>
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedAreasMaquina.obtenerCodigo}"   />
                    
                </div>
                <div align="center">
                    
                    Maquinas de :
                    <h:outputText value="#{ManagedAreasMaquina.nombreAreaFabricacion}"   />
                    <br><br>
                    <rich:dataTable value="#{ManagedAreasMaquina.areasMaquinaList}" var="data" id="dataAreasDependientes" 
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
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Maquina"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}" />
                        </h:column>
                        
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedAreasMaquina.actionAgregar}"/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedAreasMaquina.eliminarAreasMaquina}"  onclick="return eliminar('form1:dataAreasDependientes'); "/>
                    <%--h:commandButton value="Cancelar"   styleClass="btn"  action="cancelarAreaFabricacion"/--%>
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedAreasMaquina.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

