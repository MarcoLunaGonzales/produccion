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
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
             /*   function getCodigo(codigo){
                   //alert(codigo);
                   location='../principios_activos_producto/navegador_principiosactivos_producto.jsf?codigo='+codigo;
                }
                function getCodigo1(codigo){
                   //alert(codigo);
                   location='../acciones_terapeuticas_producto/navegador_accionesterapeuticas_producto.jsf?codigo='+codigo;
                }
                function getCodigo2(codigo){
                   //alert(codigo);
                   location='../productos_venta/navegador_productos_venta.jsf?codigo='+codigo;
                }       
                function getCodigo3(codigo){
                   //alert(codigo);
                   location='../productos_formas_far/navegador_productos_formasfar.jsf?codigo='+codigo;
                } */
            </script>
        </head>
        <body>
            <h:form id="form1"  >                
                <div align="center">                    
                    <br>
                    <br>
                    <h3>  <h:outputText value="Nombres Comerciales" styleClass="tituloCabezera1" />     </h3>
                    <br>
                    <br>
                    <%--h:outputText value="Ver Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{productos.productoBean.estadoProducto.codEstadoProducto}" styleClass="inputText" 
                                     valueChangeListener="#{productos.changeEvent}">
                        <f:selectItems value="#{productos.estadoproducto}"  />
                        <a4j:support event="onchange"  reRender="dataProducto"  />
                    </h:selectOneMenu> 
                    <br><br--%>
                    <rich:dataTable value="#{productos.productoList}" var="data" id="dataProducto"  
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    

                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProducto}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProd}"  />
                        </h:column>
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProducto.nombreEstadoProducto}"  />
                        </h:column--%>

                        
                        
                    </rich:dataTable>                    
                  
                    <br>
                    <h:commandButton value="Registrar" styleClass="btn"  action="#{productos.actionRegistrarProducto}" />
                    <h:commandButton value="Editar"  styleClass="btn"  action="#{productos.actionEditarProducto}" onclick="return editarItem('form1:dataProducto');"/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{productos.actionEliminarProducto}"  onclick="return eliminarItem('form1:dataProducto');"/>
                </div>                
                <!--cerrando la conexion-->
                <h:outputText value="#{productos.closeConnection}"  />
            </h:form>
            
        </body>
    </html>
    
</f:view>

