<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>

<f:view>
   
    <html>
        <head>
            <title>SISTEMA</title>
            
            <style  type="text/css">
                .sinexistencia{
                background-color : #FFCCFF;
                }
                .conexistencia{
                background-color : #FFFFFF;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                
            </style>
            
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function getCodigo(codigo){
                   location='../detalle_salidasacond/navegador_detallesalidaacond.jsf?codigo='+codigo;
                }
                function anular(){ if(confirm('Esta seguro de anular el ingreso'))  return true ;else return false;}
                
            </script>
        </head>
        <body >
            <h:form id="form1"  >
                <%--<h:outputText value="#{ManagedSalidasVentas.codigo}"       />--%>
                
                <div align="center">
                    
                    <h:outputText  value="#{ManagedPresentacionesProducto.cargarComponentespresentaciones}"  />
                        <rich:dataTable value="#{ManagedPresentacionesProducto.componentespresentaciones}" var="detalle" id="detalle"  
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                        onRowMouseOver="this.style.backgroundColor='#F1F1F1';" 
                                        styleClass="headerClassACliente2"
                                        columnClasses="tituloCampo"    >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Componentes"  />
                                    </rich:column>
                                    
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:outputText value="#{detalle.cantidadCompprod} #{detalle.envasesPrimarios.nombreEnvasePrim} #{detalle.volumenPesoEnvasePrim} #{detalle.coloresPresentacion.nombreColor} #{detalle.saboresProductos.nombreSabor}"  />
                            </rich:column>                                 
                        </rich:dataTable>
                        
                    
                </div>
                
                <!--cerrando la conexion-->
                
            </h:form>
        </body>
    </html>
    
</f:view>

