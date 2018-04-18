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
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }                
            </style>
            <script  type="text/javascript">
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error "+message+" continue con su transaccion ");
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedControlCalidadOS.cargarSeguimientoProgramaProduccionOS}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Registro de OS Programa Produccion" />
                    
                        <rich:panel style="width:70%;margin-top:12px; " headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos del Lote"/>
                            </f:facet>
                                <h:panelGrid columns="6">
                                    <h:outputText value="Programa produccion" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.nombreProgramaProduccion}" styleClass="outputText2" />
                                    <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.codLoteProduccion}" styleClass="outputText2" />
                                    <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                    <h:outputText value="Cant. Lote" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.cantidadLote}" styleClass="outputText2" />
                                    <h:outputText value="Tipo Programa Prod" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.tiposProgramaProduccion.nombreProgramaProd}" styleClass="outputText2" />
                                    <h:outputText value="Area" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                                    <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionSeleccionado.estadoProgramaProduccion.nombreEstadoProgramaProd}" styleClass="outputText2" />
                                </h:panelGrid>
                        </rich:panel>
                       
                        <rich:dataTable style="margin-top:12px;"
                                value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalOS}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                       <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Actividad"  />
                            </f:facet>
                            <h:outputText value="#{data.seguimientoProgramaProduccion.actividadesProduccion.nombreActividad}" />

                        </rich:column>
                          <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Personal"  />
                            </f:facet>
                            <h:outputText value="#{data.personal.nombrePersonal}" />


                        </rich:column>
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <br>
                                 <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="HH:mm"/>
                                </h:outputText>
                        </rich:column>

                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="OOS(Resultados fuera de especificacion)"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.os}" styleClass="inputText">
                                <f:selectItem itemLabel="--Ninguno--" itemValue='-1'/>
                                <f:selectItem itemLabel="Si" itemValue='1'/>
                                <f:selectItem itemLabel="No" itemValue='0'/>
                            </h:selectOneMenu>
                       </rich:column>
                        

                    </rich:dataTable>
                    
                    
                   <div style="margin-top:12px;">
                       <a4j:commandButton value="Guardar" action="#{ManagedControlCalidadOS.guardarOsSeguimientoProgramaProd}" oncomplete="if(#{ManagedControlCalidadOS.mensaje eq '1'}){alert('Se registro la informacion');window.location.href='navegadorProgramaProduccionOS.jsf'}else{alert('#{ManagedControlCalidadOS.mensaje}');}" styleClass="btn"/>
                       <a4j:commandButton value="Adicionar Registro OOS " oncomplete="window.location.href='registroControlCalidadOOS.jsf'" styleClass="btn"/>
                       <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorProgramaProduccionOS.jsf'" styleClass="btn"/>
                   </div>
                    
                </div>

                
            </a4j:form>
            
            
        </body>
    </html>
    
</f:view>

