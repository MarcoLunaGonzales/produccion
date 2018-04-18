
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
            <script>
                   A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            function valNumero()
            {
                if ((event.keyCode < 48 || event.keyCode > 57)&& event.keyCode!=46)
                 {
                    alert('Introduzca sólo Números');
                    event.returnValue = false;
                 }

            }
            </script>
        </head>
        <body >    
            <div style="text-align:center">                            
                <h:form id="form1"  >
                     <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="datos del producto"/>

                    </f:facet>
                    <h:panelGrid columns="3" headerClass="headerClassACliente">
                        <h:outputText value="producto " styleClass="outputText2"/>
                       <h:outputText value=":" styleClass="outputText2"/>
                       <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.nombreProdSemiterminado}   " styleClass="outputText2"/>
                        <h:outputText value="formula farmaceutica " styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedEspecificacionesControlCalidad.componentesProd.forma.nombreForma}" styleClass="outputText2"/>
                    </h:panelGrid>
                </rich:panel>
                <br>
                    <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaEspecificacionesMicrobiologia}" var="data" id="dataEspecificacionesFisicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />

                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Analisis Mirobiologico"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionMicrobiologiaCc.nombreEspecificacion}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"  />
                            </f:facet>
                            <h:inputText value="#{data.descripcion}" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}"  styleClass="inputText"/>
                            <h:panelGrid columns="3" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText" />
                            <h:outputText value="-" />
                            <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            </h:panelGrid>
                            <h:panelGrid columns="2" rendered="#{(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')&&(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')}">

                            <h:outputText value="#{data.especificacionMicrobiologiaCc.coeficiente} #{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.simbolo}" styleClass="outputText2"/>
                            <h:inputText value="#{data.valorExacto}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            </h:panelGrid>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>

                             <h:selectOneMenu value="#{data.especificacionMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedEspecificacionesControlCalidad.listaTiposReferenciaCc}"/>
                             </h:selectOneMenu>
                        </rich:column >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>

                             <h:selectOneMenu value="#{data.estado.codEstadoRegistro}">
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="No Activo"/>
                             </h:selectOneMenu>
                        </rich:column >

 
                   </rich:dataTable>

                        <a4j:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedEspecificacionesControlCalidad.guardarAnalisisMicrobiologico_Action}"
                        oncomplete="if(#{ManagedEspecificacionesControlCalidad.mensaje eq '1'}){Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100});window.location='navegador_componentesProducto.jsf';alert('Se registraron las especificaciones microbiologicas para el producto');}
                        else {alert('#{ManagedEspecificacionesControlCalidad.mensaje}');}"/>
                        <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedEspecificacionesControlCalidad.cancelar}"/>
                    </div>            
                </h:form>
                  <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
            </div>    
        </body>
    </html>
    
</f:view>

