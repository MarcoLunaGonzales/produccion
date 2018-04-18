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
                    <h:outputText value="#{ManagedPartesModulosInstalacion.obtenerCodigo}"   />
                    
                </div>
                <div align="center">
                    <br><br>
                    Partes del Módulo de Instalación : <h:outputText value="#{ManagedPartesModulosInstalacion.nombreModuloInstalacion}"   />
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
     
                    <br><br>
                    <rich:dataTable value="#{ManagedPartesModulosInstalacion.partesModulosInstalacionList}" var="data" id="dataAreasDependientes" 
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
                                <h:outputText value="Parte de Módulo"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreParteModulo}" />
                        </h:column>
                       
                        
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedPartesModulosInstalacion.actionAgregar}"/>
                    <h:commandButton value="Editar "    styleClass="btn"  action="#{ManagedPartesModulosInstalacion.actionEditar}" onclick="return editarItem('form1:dataAreasDependientes'); "/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedPartesModulosInstalacion.guardarEliminarPartesModulosInstalacion}"  onclick="return eliminar('form1:dataAreasDependientes'); "/>
                    <h:commandButton value="Cancelar"   styleClass="btn"  action="navegadorModulosInstalaciones"/>
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedPartesModulosInstalacion.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

