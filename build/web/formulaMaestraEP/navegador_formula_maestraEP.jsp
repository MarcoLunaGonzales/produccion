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
                 function getCodigo(codigo,codigo1,nombre,cantidad){
                        //alert(codigo);
                        location='../formulaMaestraDetalleEP/navegador_formula_maestra_detalleEP.jsf?codigo='+codigo+'&codigo1='+codigo1+'&nombre='+nombre+'&cantidad='+cantidad;
                 }
            </script>
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraEP.obtenerCodigo}"   />
                    
                </div>
                <div align="center">
                    
                    Empaque Primario  de: <h:outputText value="#{ManagedFormulaMaestraEP.nombreComProd}"   />
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraEP.formulaMaestraEPList}" var="data" id="dataAreasDependientes" 
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
                                <h:outputText value="Envase Primario"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesPrimarias.envasesPrimarios.nombreEnvasePrim}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesPrimarias.cantidad}" />
                        </h:column>
                         <h:column >
                            <f:facet name="header">
                                <h:outputText value="Tipos Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesPrimarias.tiposProgramaProduccion.nombreTipoProgramaProd}" />
                        </h:column>
                         <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesPrimarias.estadoReferencial.nombreEstadoRegistro}" />
                        </h:column>



                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.formulaMaestra.codFormulaMaestra}','#{data.presentacionesPrimarias.codPresentacionPrimaria}','#{data.presentacionesPrimarias.envasesPrimarios.nombreEnvasePrim}','#{data.presentacionesPrimarias.cantidad}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt=' '></a>  "  escape="false"  />
                        </h:column>   
                        
                    </rich:dataTable>
                    
                    <br>
                  <h:commandButton value="Cancelar"   styleClass="btn"  action="navegadorFormulaMaestra"/>  
                     
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraEP.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

