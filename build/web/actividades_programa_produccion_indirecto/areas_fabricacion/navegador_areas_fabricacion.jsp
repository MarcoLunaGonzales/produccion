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
            <script >
                function cogerId(obj){
                    alert(obj);
                }
                function getCodigo(codigo,codFormula,nombre,cantidad){
                
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='../areas_fabricacion/navegador_area_maquina.jsf?codigo='+codigo;
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + '' 
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                     location='../reporteExplosionProductosSimulacion/guardarReservaProgramaProd.jsf?codigo='+codigo;
                }
   
            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    
                    <h:outputText styleClass="outputTextTitulo"  value="Areas de Fabricación" />                    
                    <br>
                    <br> <br>
                    <rich:dataTable value="#{ManagedAreasFabricacion.areasFabricacionList}" var="data" id="dataFormula" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"   />
                         
                        </h:column--%>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Area de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" Maquinaria"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.areasEmpresa.codAreaEmpresa}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Maquinaria'></a>  "  escape="false"  />
                        </h:column>    
                        
                    </rich:dataTable>
                    
                    <br>
                    <%--h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.actionagregar}"/>
                    <h:commandButton value="Editar"    styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.eliminarProgProd}" onclick="return eliminar('form1:dataFormula');"/>
                    <a4j:commandButton value="Explosión"  styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.actionEliminar}"  oncomplete="location='../reporteExplosionProductosSimulacion/filtroReporteExplosion.jsf?codigos=#{ManagedProgramaProduccionSimulacion.codigos}&fecha_inicio=#{ManagedProgramaProduccionSimulacion.fecha_inicio}&fecha_final=#{ManagedProgramaProduccionSimulacion.fecha_final}'" /--%>                    
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedProgramaProduccionSimulacion.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

