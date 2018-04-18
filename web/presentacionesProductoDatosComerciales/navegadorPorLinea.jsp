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
                   location='../presentacionesProductoDatosComerciales/navegadorPresentacionesProductoBuscar.jsf?codLinea='+codigo;
                }
            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">                    
                    <h3>Linea</h3>
                    <h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.cogerCodigo}"  />
                    <rich:dataTable value="#{ManagedPresentacionesProductoDatosComerciales.lineaMKT}" var="data" id="dataAreasEmpresa" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >                       
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Linea"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codLineaMKT}');\" style='cursor:hand;text-decoration:underline' >#{data.nombreLineaMKT}</a>  "  escape="false"  />
                        </h:column>                            
                    </rich:dataTable>                                        
                </div>                
            </h:form>
            <div align="center">
                <a href="javascript:history.go(-1)">Volver Atrás</a>
            </div>
        </body>
    </html>
    
</f:view>

