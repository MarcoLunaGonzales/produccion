<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                /*FUNCION DE VALIDACION*/
                function validar(nametable){
                   var cantidadTotal=document.getElementById('form1:cantidadTotal');                   
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   var sumaTotal=0;
                   for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel1=cellsElement[1];
                        var data1=cel1.getElementsByTagName('input')[0].value;
                        sumaTotal=parseFloat(sumaTotal)+parseFloat(data1);
                   }
                   //alert(parseFloat(cantidadTotal.innerHTML) + " " + Math.round(parseFloat(sumaTotal)*100)/100);
                   sumaTotal = (Math.round(parseFloat(sumaTotal)*100)/100);
                   if(parseFloat(cantidadTotal.innerHTML)!=parseFloat(sumaTotal)){
                       alert("La suma de las cantidades es diferente a la CANTIDAD TOTAL.");
                       return false;
                   }
                   return true;
                }
                function validarFraccionMayorACero(input)
                {
                    input.backgroundColor='';
                    if(parseFloat(input.value)<=0)
                    {
                        alert('Debe registrar una cantida mayor a cero');
                        input.backgroundColor='rgb(255, 182, 193)';
                        input.focus();
                    }

                }

            </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraDetalleMpFracciones}"   />
                   <rich:panel headerClass="headerClassACliente" style="width:60%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Material" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.materiales.nombreMaterial}" styleClass="outputText2" />
                            <h:outputText value="Cantidad Total" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.cantidad}" id="cantidadTotal" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    

                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPfraccionesEditar}"
                    var="data" id="detalleFracciones"  style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:outputText value="#{data.codFormulaMaestraFracciones+1}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidades"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarFraccionMayorACero(this);" style="align-text:left;" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Material Produccion"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.tiposMaterialProduccion.codTipoMaterialProduccion}" styleClass="inputText">
                                <f:selectItems value="#{ManagedVersionesFormulaMaestra.tiposMaterialProduccionSelectList}" />
                            </h:selectOneMenu>
                        </h:column>
                    </rich:dataTable>
                    <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">

                    <div align="center" style="margin-top:0.5em">
                        <a4j:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarFormulaMaestraDetalleMpFracccionesVersion_action}"
                        onclick="if(validar('form1:detalleFracciones')==false){return false;}"
                        oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){var a=Math.random();alert('Se guardo la modificacion de fracciones');window.location.href='navegadorFormulaMaestraVersionMP.jsf?a='+a;}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"/>
                      <a4j:commandButton value="Cancelar" styleClass="btn"  oncomplete="var a=Math.random();window.location.href='navegadorFormulaMaestraVersionMP.jsf?can='+a;"/>
                   </div>
                   </h:panelGroup>

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
        </body>
    </html>

</f:view>

