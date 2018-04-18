<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
             <script src="../../js/general.js"></script>
            <script>
            function validadRegistroCantidad()
           {
               var tabla=document.getElementById("form1:dataMateriales");
               var cantidadSeleccionados=0;
               var cantidadMayorCero=0;
               for(var i=1;i<tabla.rows.length;i++)
               {
                   if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                   {
                       cantidadSeleccionados++;
                       if(parseFloat(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value)<=0)
                       {
                           tabla.rows[i].cells[2].getElementsByTagName("input")[0].focus();
                           alert("No se puede registrar materiales con cantidad 0");
                           return false;
                       }
                   }
                   if(parseFloat(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value)>0)
                   {
                       cantidadMayorCero++;
                   }
               }
               if((cantidadMayorCero!=cantidadSeleccionados)&&(cantidadSeleccionados>0))
               {
                   return confirm('Existen materiales con cantidad mayor a cero que no han sido seleccionados para su registro\nDesea guardar de todos modos?');
               }
               if(cantidadSeleccionados==0)
               {
                   alert('No se encontraron materiales para el registro');
                   return false;
               }
               return true;
           }
           function valEnteros()
            {
              if ((event.keyCode < 48 || event.keyCode > 57) )
                 {
                    alert('Introduzca solo Numeros Enteros');
                    event.returnValue = false;
                 }
            }
        function seleccionarRegistro(checked)
           {
                checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
           }
           onerror=function()
           {
               alert('Ocurrio un error de ejecución del sistema,por favor notifique a sistemas');
           };
        </script>
        </head>
        <body >
            <h:form id="form1"  >
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarAgregarFormulaMaestraDetallaEpAgregar}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
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
                            
                        </h:panelGrid>
                        <rich:panel headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos Presentacion Primaria"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Envase Primario" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.envasesPrimarios.nombreEnvasePrim}" styleClass="outputText2" />
                                <h:outputText value="Cantidad" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.cantidad}" styleClass="outputText2" />
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2" />
                            </h:panelGrid>
                        </rich:panel>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleEPAgregarList}"  var="data" id="dataMateriales"
                                    style="margin-top:0.5em"
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'"  escape="false"/>
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"   />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    
                    <div style="margin-top:0.5em">
                    <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarFormulaMaestraDetalleEpVersion_action}"
                    onclick="if(!validadRegistroCantidad()){return false;}"
                    oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registraron los materiales');var a=Math.random();window.location.href='navegadorVersionFormulaMaestraDetalleEP.jsf?agre='+a;}else
                    {alert('#{ManagedVersionesFormulaMaestra.mensaje}');}" />
                    <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='navegadorVersionFormulaMaestraDetalleEP.jsf?cana='+a;"/>
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
        </body>
    </html>
    
</f:view>

