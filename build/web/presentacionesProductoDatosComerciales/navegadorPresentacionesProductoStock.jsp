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
                function getCodigo(codigo){
                   location='../presentacionesProductoDatosComerciales/navegadorDetalleDatosComerciales.jsf?codigo='+codigo;
                }
                
                
                var html=null;
                var div=null;
                function fin(){
                    document.getElementById('form1:panelBuscar1').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';
                    if(div!=null){
                        div.style.visibility='hidden';
                    }
                }
                
                function espera(){
                    div=document.getElementById('A');
                    if(document.getElementById('A')==null){
                        div=document.createElement('div');
                        div.style.left=document.getElementById('form1:panelBuscar1').style.left;
                        div.style.top=document.getElementById('form1:panelBuscar1').style.top;
                        div.innerHTML="<div align='center' class='outputText2'>Espere por favor...<br/><img src='../img/load.gif'></span>";
                        div.className='panelActivarFuncionario';
                        div.style.border='1px solid #000000';
                        div.style.padding='20px';
                        div.id='A';
                        document.body.appendChild(div);
                    }else{
                        div.style.left=document.getElementById('form1:panelBuscar1').style.left;
                        div.style.top=document.getElementById('form1:panelBuscar1').style.top;
                        div.className='panelActivarFuncionario';
                        div.style.border='1px solid #000000';
                        div.id='A';
                    }
                    div.style.visibility='visible';
                    
                    
                    
                }
                function constructor(){
                    document.getElementById('form1:panelBuscar1').style.left=parseInt(window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft-600)+'px';
                    document.getElementById('form1:panelBuscar1').style.top=parseInt(window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop)+'px';

                    
                }
                function foo2(){

                    document.getElementById('form1:panelBuscar1').style.visibility='visible';
                    document.getElementById('panelsuper').style.visibility='visible';
                    document.getElementById('form1:stockMinimo').focus();
                    
                    
                }
            
                
            </script>
            <style type="text/css">
                .panelSuper2{
                padding: 50px;
                /*background-image : url(../img/proceso.gif);*/
                background-color: #cccccc;
                top: 0px;
                z-index: 2; 
                left: 0px; 
                position: absolute;
                border :2px solid #3C8BDA; 
                width :2000px;
                height: 6000px;
                filter: alpha(opacity=70);
                opacity: 0.8;
                }
            </style>
        </head>
        <body onload="carga();document.getElementById('form1:panelBuscar1').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';">
            <h:form id="form1"  >                
                <div align="center">
                    <h3>Stock de Productos</h3>                    
                    <h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.cogerCodigoStock}"  />
                    
                    
                    
                    <rich:panel headerClass="headerClassACliente" id="panelBuscar1" styleClass="panelActivarFuncionario" style="top:100px;left:150px;visibility:visible" >
                        <f:facet name="header">
                            <h:outputText  value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar1');\"  >Modificar Stock</div> " escape="false"  />                    
                        </f:facet>
                        
                        <h:panelGrid columns="2" border="0" width="90%" id="paneluno">
                            <h:outputText value="Stock Minimo" styleClass="outputText2" />
                            <h:inputText   onkeypress="valNum();"  styleClass="inputText" size="20"  value="#{ManagedPresentacionesProductoDatosComerciales.stockMinimo}"  id="stockMinimo" />
                            <h:outputText value="Stock Seguridad" styleClass="outputText2" />
                            <h:inputText   onkeypress="valNum();"  styleClass="inputText" size="20"  value="#{ManagedPresentacionesProductoDatosComerciales.stockSeguridad}"  id="stockSeguridad"  />
                            <h:outputText value="Stock Maximo" styleClass="outputText2" />
                            <h:inputText   onkeypress="valNum();"  styleClass="inputText" size="20" value="#{ManagedPresentacionesProductoDatosComerciales.stockMaximo}"  id="stockMaximo" />
                            <a4j:commandButton value="Modificar"  styleClass="commandButton" actionListener="#{ManagedPresentacionesProductoDatosComerciales.modificar}"   oncomplete="fin();" onclick="espera();"  reRender="dataPresentacionProducto" />
                            <h:commandButton value="Cancelar"  styleClass="commandButton" type="button"  onclick="document.getElementById('form1:panelBuscar1').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';" />
                        </h:panelGrid>
                        
                        
                        
                        
                    </rich:panel>
                    
                    
                    <rich:dataTable value="#{ManagedPresentacionesProductoDatosComerciales.datamodel}" var="data" id="dataPresentacionProducto" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"                                     
                   headerClass="headerClassACliente" >
                        
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Producto" styleClass="outputText2" />                                                                        
                                </rich:column>                                
                                <rich:column>
                                    <h:outputText value="Stock Minimo" styleClass="outputText2" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Stock Seguridad" styleClass="outputText2" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Stock Maximo" styleClass="outputText2" />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="" styleClass="outputText2" />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        
                        <rich:column>
                            <h:commandLink  action="#{ManagedPresentacionesProductoDatosComerciales.escogerProducto}">
                                <h:outputText value="#{data[1]}" styleClass="outputTextNormal" />
                            </h:commandLink>                            
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data[2]}" styleClass="outputTextNormal" style="text-align:right" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data[3]}" styleClass="outputTextNormal" style="text-align:right">
                                <f:convertNumber maxFractionDigits="2" minFractionDigits="2"  />
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data[4]}" styleClass="outputTextNormal" style="text-align:right" />
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink actionListener="#{ManagedPresentacionesProductoDatosComerciales.preModificar}" onclick="constructor();"  reRender="stockMinimo,stockSeguridad,stockMaximo" oncomplete="foo2();">
                                <h:graphicImage url="../img/edit.jpg"   style="border:none" />
                            </a4j:commandLink>
                        </rich:column>
                        
                        
                    </rich:dataTable>                                      
                </div>                               
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedPresentacionesProductoDatosComerciales.closeConnection}"  />
            </h:form>
            <h:panelGroup   id="panelsuper"  styleClass="panelSuper2"  >
                
                
            </h:panelGroup>
            
        </body>
    </html>
    
</f:view>

