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
                function cogerId(obj){
                    alert(obj);
                   
                  
                }
                function getCodigo(codigo,codFormula,nombre,cantidad, codProd,codLoteProd,codTipoProgramaProd){
                  //  alert(codLoteProd);
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&codCompProd='+codProd+'&cod_lote_prod='+codLoteProd+'&codTipoProgramaProd='+codTipoProgramaProd;
                  //alert(url);
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                
                  		
                  location='../reporteExplosionProductosSimulacion/guardarReservaProgramaProd.jsf?codigo='+codigo;


                }

                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    //alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }    
                
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
    function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     function enviar(codProgramaProduccion, codigo, fecha_ini, fecha_fin,conProductosEnProceso){
        var ajax=nuevoAjax();
        var valores='codProgramaProduccion='+codProgramaProduccion+'&codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin+'&conProductosEnProceso='+conProductosEnProceso;
        valores+='&pq='+(Math.random()*1000);        
        var url='../reporteExplosionProductosSimulacion/filtroReporteExplosion.jsf';
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
           /* var p=document.createElement('img');
             p.src='../img/load.gif';
             var div=document.createElement('div');
             div.style.paddingTop='150px';
             div.style.paddingLeft='20px';
             div.style.textAlign='center';
             div.style.top='0px';
             div.style.left='0px';
             div.style.position='absolute';
             div.innerHTML='CARGANDO...';
             div.style.fontFamily='Verdana';
             div.style.fontSize='11px';
             div.style.width='200px';
             div.appendChild(p);
             div.style.filter='alpha(opacity=40)';
             main.appendChild(div);
             
             */
             document.getElementById('contenido').style.visibility='visible';
             document.getElementById('contenido').style.zIndex = 5;
             document.getElementById('contenido').style.backgroundColor="#f2f2f2";
             document.getElementById('botones').style.visibility='hidden';
             //document.getElementById('botones').style.left=0px;
             //document.getElementById('botones').style.top=0px;
             
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        }
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    function seleccionarTodo(){
       //alert('entro');
       var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
       var elements=document.getElementById('form1:dataFormula');

       if(seleccionar_todo.checked==true){  
         //alert('entro por verdad');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=true;
                }
            }
       }
       else
       {//alert('entro por false');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=false;
                }
            }

       }
       return true;

    }
    function trim (myString)
                {
                    return myString.replace(/^\s+/g,'').replace(/\s+$/g,'')
                }

     function seleccionarItem(nametable,producto,lote,check){
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    
                    //se verifica si esta seleccionado
                    //alert(check.checked);

                    if(check.checked==true){
                       for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=true;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }else{
                         for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=false;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }

                   
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
</head>
<body >
    
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >
        
        <h:outputText value="#{ManagedProgramaProduccionSimulacion.cargarProgramaProduccion1}"  />
        <h:outputText styleClass="outputTextTitulo"  value="Simulación de Programas de Producción " />                    
        <br><br>
        <h:outputText styleClass="outputTextTitulo"  value="Area Fabricacion:" />                    
        <h:selectOneMenu value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText"  
                         valueChangeListener="#{ManagedProgramaProduccionSimulacion.changeEvent1}">
            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.areasEmpresaList}"  />
            <a4j:support event="onchange"  reRender="dataFormula"  />
        </h:selectOneMenu>  
        <br> <br>
        <h:outputText styleClass="outputTextTitulo"  value="Tipo de Producción" />                    
        <h:selectOneMenu value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText"  
                         valueChangeListener="#{ManagedProgramaProduccionSimulacion.changeEvent2}">
            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.tiposProgramaProdList}"  />
            <a4j:support event="onchange"  reRender="dataFormula"  />
        </h:selectOneMenu>  
        <br> <br>
        <h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo();"/>
        <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" />
        <br> <br>
        
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionList}" var="data" id="dataFormula" 
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente"
                        binding="#{ManagedProgramaProduccionSimulacion.programaProduccionDataTable}" >
            <h:column>
                <f:facet name="header">
                    <h:outputText value=""  />
                    
                </f:facet>
                <h:selectBooleanCheckbox value="#{data.checked}"
                >
                    <%-- onclick="seleccionarItem('form1:dataFormula','#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}',#{data.codLoteProduccion},this)" --%>
                    
                    
                </h:selectBooleanCheckbox>
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Producto"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
            </h:column>
              <%--
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Lote"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.cantidadLote}"  />
            </h:column>     
           <h:column>
                <f:facet name="header">
                    <h:outputText value="Nro. de Lotes a Producir"  />
                </f:facet>
                <h:outputText value="#{data.cantidadLote}"  />
            </h:column> --%>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="cantidad de Lote"  />
                </f:facet>
                <h:outputText value="#{data.cantidadLote}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Lote"  />
                </f:facet>
                <h:outputText value="#{data.codLoteProduccion}"  />
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Categoría"  />
                </f:facet>
                <h:outputText value="#{categoriasCompProd.nombreCategoriaCompProd}"  />
            </h:column>
            
            
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Observación"  />
                </f:facet>
                <h:outputText value="#{data.observacion}" />
            </h:column>
            
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Tipo Programa Producción"  />
                </f:facet>
                <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
            </h:column>
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Estado"  />
                </f:facet>
                <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
            </h:column>
            <%--h:column >
                <f:facet name="header">
                    <h:outputText value="Estado Simulacion"  />
                </f:facet>
                <h:graphicImage url="../img/bien.png" rendered="#{data.estadoProductoSimulacion==0}" />
                <h:graphicImage url="../img/error.png" rendered="#{data.estadoProductoSimulacion==1}" />
                <h:graphicImage url="../img/mal.png" rendered="#{data.estadoProductoSimulacion==2}" />
            </h:column--%>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value=""  />
                </f:facet>
                <h:outputText value="<a  onclick=\"getCodigo('#{data.codProgramaProduccion}','#{data.formulaMaestra.codFormulaMaestra}','#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}','#{data.formulaMaestra.cantidadLote}','#{data.formulaMaestra.componentesProd.codCompprod}','#{data.codLoteProduccion}','#{data.tiposProgramaProduccion.codTipoProgramaProd}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Detalle'></a>  "  escape="false"  />
            </h:column>
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Lugar Acond"  />
                </f:facet>
                <h:outputText value="#{data.lugaresAcond.nombreLugarAcond}" />
            </h:column>
            
        </rich:dataTable>
        
        <br>
        <div align="center" style="" id="botones"  >
            <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.agregarProgramaProduccionSimulacion_action}"/>
            <h:commandButton value="Editar"    styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.editarProgramaProduccion_action1}" /> <%-- onclick="return eliminarItem('form1:dataFormula');" --%>
            <h:commandButton value="Eliminar"    styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.eliminarProgramaProduccion_action1}" onclick="if(confirm('Estado seguro de Eliminar?')==false){return false;}" />
            <a4j:commandButton value="Explosión Materiales"  styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.actionEliminar}"  oncomplete="if(confirm('Con productos en Proceso?')==true){enviar('#{ManagedProgramaProduccionSimulacion.codProgramaProd}','#{ManagedProgramaProduccionSimulacion.codigos}','#{ManagedProgramaProduccionSimulacion.fecha_inicio}','#{ManagedProgramaProduccionSimulacion.fecha_final}','1')}
                                                                                                                                                                                                     else{enviar('#{ManagedProgramaProduccionSimulacion.codProgramaProd}','#{ManagedProgramaProduccionSimulacion.codigos}','#{ManagedProgramaProduccionSimulacion.fecha_inicio}','#{ManagedProgramaProduccionSimulacion.fecha_final}','0')}" />
            <%--h:commandButton value="Explosión Maquinaria"  styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.explosionMaquinaria}"   /--%>
            <a4j:commandButton value="Explosion de Maquinaria" action="#{ManagedProgramaProduccionSimulacion.explosionMaquinaria}" styleClass="btn" oncomplete="openPopup('../reportes/explosionMaquinarias/navegadorReporteExplosionMaquinarias.jsf')" />
            
            <a4j:commandButton styleClass="btn" onclick="location='navegador_programa_produccion_lotes.jsf'" value="cancelar" />

        </div>
        
        <div align="center" style="visibility:hidden; " id="contenido"  >
            
            
            
            
            
            
            <p>Cargando.....</p>  
            <img src="../img/load.gif" valign="center" > 
        </div>
        
    </div>
    <!--cerrando la conexion-->
    <h:outputText value="#{ManagedProgramaProduccionSimulacion.closeConnection}"  />
    </a4j:form>
    
</body>
</html>

</f:view>

