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
                function validarRegistro(){
                   if(document.getElementById('form1:producto').value==0){
                         alert('No selecciono el nombre Comercial.');
                         producto.focus();
                         return false;
                   }
                   if(document.getElementById('form1:cantidad').value ==''||
                   parseInt(document.getElementById('form1:cantidad').value)<=0){
                         alert('la cantidad debe ser mayor a 0');
                         cantidad.focus();
                         return false;
                   }                                         
                                                       
                                           
                   if(document.getElementById('form1:nombrePresentacion').value==''){
                         alert('El campo Nombre de Presentación está vacio.');
                         nombrePresentacion.focus();
                         return false;
                   }                                         
                  
                   return true;
                }
                  function visibilityPanel(){
                        document.getElementById('form1:panelBuscar').style.visibility='hidden';
                        document.getElementById('panelsuper').style.visibility='hidden';
                        
                 }
                 function cargarDatos(){
                    var producto=document.getElementById("form1:producto");
                    var nombrePresentacion=document.getElementById("form1:nombrePresentacion");
                    var envaseTerciario=document.getElementById("form1:envaseTerciario");
                    var cantidad=document.getElementById("form1:cantidad");
                    
                    nombrePresentacion.value=producto.options[producto.selectedIndex].text+" "+envaseTerciario.options[envaseTerciario.selectedIndex].text+" x "+cantidad.value;
                 }
                 function crearNombrePresentacionProducto()
                 {
                     document.getElementById("form1:nombrePresentacion").value=
                     document.getElementById("form1:producto").options[document.getElementById("form1:producto").selectedIndex].innerHTML+' '+
                     document.getElementById("form1:envaseSecundario").options[document.getElementById("form1:envaseSecundario").selectedIndex].innerHTML+' X '+
                     document.getElementById("form1:cantidad").value;
                 
                 }
            </script>
        </head>
        <body>

            <a4j:form id="form1"  >                
                <div align="center">
                    
                    <h:outputText value="#{ManagedPresentacionesProducto.cargarAgregarNuevaPresentacion}"/>
                    
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                        <f:facet name="header">
                            <h:outputText value="Registrar Presentación de Producto"/>
                        </f:facet>
                            <h:panelGrid columns="3"  >
                                <h:outputText value="Nombre Comercial" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu  id="producto" onchange="crearNombrePresentacionProducto();" styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.producto.codProducto}">
                                      <f:selectItems value="#{ManagedPresentacionesProducto.productosSelectList}"  />
                                </h:selectOneMenu>

                                <h:outputText value="Tipo Presentacion" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu id="tipoPresentacion" styleClass="inputText"
                                value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.tiposPresentacion.codTipoPresentacion}">
                                    <f:selectItems value="#{ManagedPresentacionesProducto.tiposPresentacionSelecList}"  />
                                </h:selectOneMenu>
                                <h:outputText value="Cantidad de Presentación" styleClass="outputTextBold"  />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:inputText  styleClass="inputText" id="cantidad" onkeyup="crearNombrePresentacionProducto();" size="10"  onkeypress="valNum();" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.cantidadPresentacion}" style='text-transform:uppercase;'/>
                                <h:outputText value="Envase Secundario" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" onchange="crearNombrePresentacionProducto();" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.envasesSecundarios.codEnvaseSec}" id="envaseSecundario" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.envasesSecundariosSelectList}"  />
                                </h:selectOneMenu>
                                <h:outputText value="Tipo de Mercaderia" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.tiposMercaderia.codTipoMercaderia}" id="tipoMercaderia" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.tiposMercaderiaSelectList}"  />
                                </h:selectOneMenu>
                                <h:outputText styleClass="outputTextBold"  value="Línea"  />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.lineaMKT.codLineaMKT}" id="lineaMKT" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.lineasMKTSelectList}"   />
                                </h:selectOneMenu>
                                <h:outputText styleClass="outputTextBold"  value="Categoria"  />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.categoriasProducto.codCategoria}" id="codCategoria" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.categoriaProductoSelectList}"   />
                                </h:selectOneMenu>
                                <h:outputText value="Descripción" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.obsPresentacion}"   />
                                <h:outputText value="Código Alfanumérico" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:inputText styleClass="inputText"  size="50" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.codAnterior}"   />
                                <h:outputText value="Nombre de la Presentación" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:inputTextarea styleClass="inputText"  cols="50" rows="2" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.nombreProductoPresentacion}" id="nombrePresentacion"  onkeypress="valMAY();"  />
                                <h:outputText value="Estado" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.estadoReferencial.codEstadoRegistro}" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.estadosPresentacionesProductoSelectList}"  />
                                </h:selectOneMenu>
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputTextBold"   />
                                <h:outputText styleClass="outputTextBold" value="::"  />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedPresentacionesProducto.presentacionesProductoAgregar.tiposProgramaProduccion.codTipoProgramaProd}" >
                                    <f:selectItems value="#{ManagedPresentacionesProducto.tiposProgramaProduccionSelectList}"  />
                                </h:selectOneMenu>
                            </h:panelGrid>
                    </rich:panel>
                    <div style="margin-top:1em;text-align:center;">
                        <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedPresentacionesProducto.guardarNuevaPresentacionProducto_action}" onclick="if(!validarRegistro()){return false;}"
                        oncomplete="if(#{ManagedPresentacionesProducto.mensaje eq '1'}){alert('Se registro la presentación secundaria');window.location.href='navegadorPresentacionesProducto.jsf?data=(new Date()).getTime().toString();'}
                        else{alert('#{ManagedPresentacionesProducto.mensaje}');}"/>
                        <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorPresentacionesProducto.jsf?cancel=(new Date()).getTime().toString();'"/>
                    </div>
                </div>
            </a4j:form>

             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>
            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="200" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
           </rich:modalPanel>
        </body>
    </html>
    
</f:view>

