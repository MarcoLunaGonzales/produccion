<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function repetir(obj){
                        var col=obj.parentNode.id;
                        var elements=document.getElementById('form1:resultadoBuscarComponente');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[col];
                                var valor;
                                if(i==1){
                                    valor=cel.getElementsByTagName('input')[0].value;
                                    valor=(valor=='')?0:valor;
                                    cel.getElementsByTagName('input')[0].value=valor;
                                }
                                   cel.getElementsByTagName('input')[0].value=valor;
                            }
                    }
                function validar(){
                   var cantidad=document.getElementById('form1:cantidad');
                       pesoNeto=document.getElementById('form1:pesoNeto');
                   if(pesoNeto.value==''){
                         alert('El campo Peso Neto esta vacio.');
                         pesoNeto.focus();
                         return false;
                   }                       
                   if(cantidad.value==''){
                         alert('El campo Cantidad esta vacio.');
                         cantidad.focus();
                           return false;
                   }
                                                    
                   return true;
                }  
                                            </script>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">
                    <!--buscar componentes-->
                    <h:outputText styleClass="tituloCabezera1" value="MODIFICAR DETALLE DE PRECIOS DE PRODUCTOS" />
                    <rich:panel  headerClass="headerClassACliente" style="width:100%">
                        <f:facet name="header">
                            <h:outputText value="Producto de Venta"  />
                        </f:facet>
                        <h:outputText styleClass="outputTextNormal" value="#{ManagedPresentacionesProductoDatosComerciales.nombreproducto}" />
                    </rich:panel>
                    
                    <rich:dataTable  value="#{ManagedPresentacionesProductoDatosComerciales.agenciasVentaList}"  
                                     width="100%"  var="data" 
                                     columnClasses="tituloCampo"
                                     headerClass="headerClassACliente"
                                     onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                     
                                     id="resultadoBuscarComponente" >
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Agencias de Venta"  />
                            </f:facet>
                            <h:outputText   value="#{data.areasEmpresa.nombreAreaEmpresa}"  /> 
                        </rich:column> 
                        <%--<rich:column>
                            <f:facet name="header">
                                <h:outputText value="Stock Mínimo"  />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.stockMinimo}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Stock Seguridad"  />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.stockSeguridad}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Stock Máximo"  />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.stockMaximo}" onkeypress="valNum();" /> 
                        </rich:column> --%>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="<div id=\"1\"  name=\"1\"><span>Precio Lista</span> <img src=\"../img/rep.png\"   onclick=\"repetir(this);\"  onmouseover=\"this.style.cursor='hand';this.src='../img/rep2.png'\" onmouseout=\"this.src='../img/rep.png'\"   alt='Repetir'></div> "  escape="false" />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.precioLista}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="<div id=\"2\"  name=\"2\"><span>Precio Mínimo</span> <img src=\"../img/rep.png\"   onclick=\"repetir(this);\"     alt='Repetir'  onmouseover=\"this.style.cursor='hand';this.src='../img/rep2.png'\" onmouseout=\"this.src='../img/rep.png'\"></div> "  escape="false" />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.precioMinimo}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="<div id=\"3\"  name=\"3\"><span>Precio Venta Corriente</span> <img src=\"../img/rep.png\"   onclick=\"repetir(this);\"      alt='Repetir' onmouseover=\"this.style.cursor='hand';this.src='../img/rep2.png'\" onmouseout=\"this.src='../img/rep.png'\"></div> "  escape="false" />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.precioVentaCorriente}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="<div id=\"4\"  name=\"4\"><span>Precio Especial</span> <img src=\"../img/rep.png\"   onclick=\"repetir(this);\"     alt='Repetir' onmouseover=\"this.style.cursor='hand';this.src='../img/rep2.png'\" onmouseout=\"this.src='../img/rep.png'\"></div> "  escape="false" />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.precioEspecial}" onkeypress="valNum();" /> 
                        </rich:column> 
                        <%--<rich:column>
                            <f:facet name="header">
                                <h:outputText value="<div id=\"4\"  name=\"4\"><span>Precio Institucional</span> <img src=\"../img/rep.png\"   onclick=\"repetir(this);\"     alt='Repetir' onmouseover=\"this.style.cursor='hand';this.src='../img/rep2.png'\" onmouseout=\"this.src='../img/rep.png'\"></div> "  escape="false" />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="15" value="#{data.precioInstitucional}" onkeypress="valNum();" /> 
                        </rich:column> --%>
                    </rich:dataTable>
                    
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedPresentacionesProductoDatosComerciales.EditPresentacionesProductoDatosComerciales}"/>
                    
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedPresentacionesProductoDatosComerciales.Cancelar1}" />
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

