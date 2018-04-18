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
            <script type="text/javascript">
                function tiposMaterialReactivo_change(){
                    //document.getElementById("form1:codTipoMaterialReactivo").selectedIndex=0;
                    document.getElementById("form1:nombreTipoMaterialReactivo").value =  document.getElementById('form1:codTipoMaterialReactivo')[document.getElementById('form1:codTipoMaterialReactivo').selectedIndex].innerHTML;
                    
                }
                function bodyLoad(){
                    tiposMaterialReactivo_change();
                }
            </script>
        </head>
        <body onload="bodyLoad()" >
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMP.cargarTiposReactivos}"   />
                    
                </div>
                <div align="center">
                    
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.tiposReactivosList}"
                                    var="data" id="dataAreasDependientes"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Tipo Reactivo"  />
                            </f:facet>
                            <h:outputText  value="#{data.nombreTipoReactivo}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="" />
                            </f:facet>
                            <h:commandLink value="ingresar" />
                        </h:column>


                    </rich:dataTable>
                    
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraDetalleMP.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

