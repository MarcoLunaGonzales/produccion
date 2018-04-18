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
                function getCodigo(codigo){                                                         
                      location='../presentacionesProductoDatosComerciales/navegadorPorLinea.jsf?codigoAreaEmpresa='+codigo;                   
                }
            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">                    
                    <h3>Precios de Producto</h3>                                        
                    <rich:dataTable value="#{ManagedPresentacionesProductoDatosComerciales.areasAgencias}" var="data" id="dataAreasEmpresa" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >                       
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" Agencia"  />
                            </f:facet>                            
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.areasEmpresa.codAreaEmpresa}');\" style='cursor:hand;text-decoration:underline' >#{data.areasEmpresa.nombreAreaEmpresa}</a>  "  escape="false"  />
                        </h:column>                            
                    </rich:dataTable>                                        
                </div>                
            </h:form>
            
        </body>
    </html>
    
</f:view>

