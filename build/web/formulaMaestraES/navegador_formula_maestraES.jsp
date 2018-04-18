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
                 /*function getCodigo(codigo,codigo1,nombre,cantidad){
                        //alert(codigo);
                        location='../formulaMaestraDetalleES/navegador_formula_maestraES.jsf?codigo='+codigo+'&codigo1='+codigo1+'&nombre='+nombre+'&cantidad='+cantidad;
                 }*/
            </script>
            <script>
                //inicio ale tipo
                 function getCodigo(codigo,codigo1,nombre,cantidad,codTipoProg,nombreTipoProg){
                        //alert(codigo);

                        location='../formulaMaestraDetalleES/navegador_formula_maestraES.jsf?codigo='+codigo+'&codigo1='+codigo1+'&nombre='+nombre+'&cantidad='+cantidad+'&codTipoProg='+codTipoProg+'&nombreTipoProg='+nombreTipoProg;
                 }
                 //final ale tipo
            </script>
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraEP.obtenerCodigo}"   />
                    
                </div>
                <div align="center">
                    
                    Empaque Secundario  de: <h:outputText value="#{ManagedFormulaMaestraEP.nombreComProd}"   />
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraEP.formulaMaestraESList}" var="data" id="dataAreasDependientes" 
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
                                <h:outputText value="Presentacion Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesProducto.tiposProgramaProduccion.nombreProgramaProd}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesProducto.cantidadPresentacion}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <%--a4j:commandLink onclick="getCodigo('#{ManagedFormulaMaestraEP.codigo}','#{data.presentacionesProducto.codPresentacion}',
                            '#{data.presentacionesProducto.nombreProductoPresentacion}','#{data.presentacionesProducto.cantidadPresentacion}')" >
                                <h:graphicImage  url="../img/cargos.jpg" />
                            </a4j:commandLink--%>
                            <a4j:commandLink onclick="getCodigo('#{ManagedFormulaMaestraEP.codigo}','#{data.presentacionesProducto.codPresentacion}',
                            '#{data.presentacionesProducto.nombreProductoPresentacion}','#{data.presentacionesProducto.cantidadPresentacion}'
                             ,'#{data.presentacionesProducto.tiposProgramaProduccion.codTipoProgramaProd}','#{data.presentacionesProducto.tiposProgramaProduccion.nombreProgramaProd}')" >
                                <h:graphicImage  url="../img/cargos.jpg" />
                            </a4j:commandLink>
                            <%--h:outputText value="<a  onclick=\"getCodigo('#{ManagedFormulaMaestraEP.codigo}','#{data.presentacionesProducto.codPresentacion}','#{data.presentacionesProducto.nombreProductoPresentacion}','#{data.presentacionesProducto.cantidadPresentacion}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt=' '></a>  "  escape="false"  /--%>
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

