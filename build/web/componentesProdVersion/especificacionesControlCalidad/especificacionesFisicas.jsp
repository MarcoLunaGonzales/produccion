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
            function seleccionarRegistro(checked)
            {
                checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
            }
            function retornarNavegador(codTipoModificacionProducto)
            {
                var url="";
                switch(codTipoModificacionProducto)
                {
                    case 1:
                    {
                        url="navegadorNuevosComponentesProd";
                        break;
                    }
                    case 2:
                    {
                        url="navegadorNuevosTamaniosLote";
                        break;
                    }
                    case 3:
                    {
                        url="navegadorComponentesProdVersion";
                        break;
                    }
                    case 4:
                    {
                        url="navegadorNuevosComponentesProd";
                        break;
                    }
                }
                window.location.href="../"+url+".jsf?ef="+(new Date()).getTime().toString();
            }
            </script>
            <style>
                .activo
                {
                    background-color:#90EE90;
                }
            </style>
        </head>
        <body >    
            <center>
                <h:outputText value="#{ManagedComponentesProdVersion.cargarEspecificacionesFisicasProducto}"/>
                <h:form id="form1"  >
                <rich:panel headerClass="headerClassACliente" style="width:60%">
                    <f:facet name="header">
                        <h:outputText value="DATOS DEL PRODUCTO"/>

                    </f:facet>
                     <h:panelGrid columns="3">
                            <h:outputText value="Nombre Producto Semiterminado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.producto.nombreProducto}" styleClass="outputText2"/>
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma}" styleClass="outputText2"/>
                            <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>

                    </h:panelGrid>
                    
                </rich:panel>
                <br>
                    <table cellpadding="0" cellspacing="0">
                        <tr><td class="outputTextBold">Habilitado</td><td class="activo" style="width:5em;">&nbsp;</td></tr>
                    </table>
                <br>
                <rich:dataTable value="#{ManagedComponentesProdVersion.especificacionesFisicasProductoList}" var="data" id="dataEspecificacionesFisicas"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Habilitado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Analisis Físico"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Especificaciones"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Referencia"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:columnGroup style="background-color:#{data.checked?'#90EE90':''}">
                            <rich:column >
                                <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this);" />
                            </rich:column >
                            <rich:column >
                                <h:outputText value="#{data.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column >
                                <center><h:inputText value="#{data.descripcion}" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/></center>
                                <h:panelGrid columns="3" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}" >
                                    <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                <h:outputText value="-" styleClass="outputText2"/>
                                <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                </h:panelGrid>
                                <h:panelGrid columns="2" rendered="#{(data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2')&&(data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')}">
                                <h:outputText value="#{data.especificacionFisicaCC.coeficiente} #{data.especificacionFisicaCC.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                <h:inputText value="#{data.valorExacto}"  onkeypress="valNumero()" size="5" styleClass="inputText"/>
                                </h:panelGrid>
                            </rich:column >
                             <rich:column >

                                 <h:selectOneMenu value="#{data.especificacionFisicaCC.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                     <f:selectItems value="#{ManagedComponentesProdVersion.tiposReferenciaCcSelect}"/>
                                 </h:selectOneMenu>
                            </rich:column >
                            <rich:column >
                                <h:outputText value="#{data.tiposEspecificacionesFisicas.nombreTipoEspecificacionFisica}"/>
                            </rich:column >
                        </rich:columnGroup>
                   </rich:dataTable>
                        <div style="margin-top:1em">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarEspecificacionesFisicasProducto_action}"
                                               timeout="7200" oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se guardaron las especificaciones fisicas');retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto});}
                            else{alert('#{ManagedComponentesProdVersion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="retornarNavegador(#{ManagedComponentesProdVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto});"/>
                        </div>

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

            </center>
        </body>
    </html>
    
</f:view>

