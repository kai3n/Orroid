require "json"

load "secure/report.rb"

def make_report( report_array )
	
	high = 0
	medium = 0
	low = 0

	bodyHash = Hash.new

	report_array.each do |report|
		if $language == "E"
			fd = open("secure/pattern_json_E/" + report.idx + ".json","r:utf-8")
		else
			fd = open("secure/pattern_json_K/" + report.idx + ".json","r:utf-8")
		end

		data = fd.read()

		parsed = JSON.parse(data)

		cellcolor = 0

		if parsed["Level"] == "High"
			cellcolor = "classsection4"
			high += 1
		end

		if parsed["Level"] == "Medium"
			cellcolor = "classsection2"
			medium += 1
		end

		if parsed["Level"] == "Low"
			cellcolor = "classsection1"
			low += 1
		end
		 

		bodyH = 
		"
		<!-- 1 basic-->
					<table border = 0 width = 100% align = center cellspacing = 0>
						<tr onClick = \"toggle('#{parsed["No"]}')\" onMouseover=\"this.style.cursor=\'pointer\'\" class = #{cellcolor}>
							<td width = 10%><h2>#{parsed["No"]}<!-- json.No--></h2></td>
							<td width = 80%><h2>#{parsed["Subject"]}<!-- json.Subject--></h2></td>
							<td width = 10%><h2>#{parsed["Level"]}<!-- json.Level--></h2></td>
						</tr>
					</table>
					<!-- 1 basic finish-->

					<!-- 1 detail-->
					<div id='#{parsed["No"]}' style='display: none;'>
						<table border = 0 width = 100% align = center cellspacing = 0>
							<tr>
								<td class = 'classh1' width = 100% colspan = 2><font color='#053958' style='font-weight: bold'><h2>Description</h2></font></td>
							</tr>

							<tr>
								<td width = 100% style='border-bottom:2px solid green;' colspan = 2>#{parsed["Description"]}<!-- json.Description--></td>
							</tr>
		"
		if report.idx == "ORR30"
			bodyM = 
			"
								<tr>
									<td width = 30% style='border-top:2px solid pink;'><font color='#053958' style='font-weight: bold'>Vuln Class</font></td>
									<td width = 70% style='border-top:2px solid pink;'>#{report.klass}</td>
								</tr>
								<tr>
									<td><font color='#053958' style='font-weight: bold'>Vuln Line</font></td>
									<td>#{report.line}</td>
								</tr>
								<tr>
									<td><font color='#053958' style='font-weight: bold; '>Vuln Code</font></td>
									<td>#{report.code}</td>
								</tr>
								</table>
							<br><br>
							<table border = 0 width = 90% align = center cellspacing = 0>

							<tr><td colspan = 5><font color='#c51010' style='font-weight: bold' >&lt; Code Trace &gt;</font></td><tr>
							
							<tr class = classsection5 >
								<td width = 5% ><font color='#053958' style='font-weight: bold; '><h2>Seq</h2></font></td>
								<td width = 20% ><font color='#053958' style='font-weight: bold; '><h2>Class</h2></font></td>
								<td width = 20% ><font color='#053958' style='font-weight: bold; '><h2>Method</h2></font></td>
								<td width = 5% ><font color='#053958' style='font-weight: bold; '><h2>Line</h2></font></td>
								<td width = 50% ><font color='#053958' style='font-weight: bold; '><h2>Source Code</h2></font></td>
							</tr>"
			for i in 0..report.info_stack.stack.length-1
				if report.info_stack.stack[i].flag
					bodyM +=
					"
								<tr>
									<td width = 5% style='border-bottom:2px solid LightGray ;'><font color='#FF0000' style='font-weight: bold; '>#{(i+1).to_s}</font></td>
									<td width = 20% style='border-bottom:2px solid LightGray ;'><font color='#FF0000' style='font-weight: bold; '>#{report.info_stack.stack[i].class_name}</font></td>
									<td width = 20% style='border-bottom:2px solid LightGray ;'><font color='#FF0000' style='font-weight: bold; '>#{report.info_stack.stack[i].method_name}</font></td>
									<td width = 5% style='border-bottom:2px solid LightGray ;'><font color='#FF0000' style='font-weight: bold; '>#{report.info_stack.stack[i].line+1}</font></td>
									<td width = 50% style='border-bottom:2px solid LightGray ;'><font color='#FF0000' style='font-weight: bold; '>#{report.info_stack.stack[i].code}</font></td>
								</tr>
					"
				else
					bodyM +=
					"
								<tr>
									<td width = 5% style='border-bottom:2px solid LightGray ;'><font color='#053958' style='font-weight: bold; '>#{(i+1).to_s}</font></td>
									<td width = 20% style='border-bottom:2px solid LightGray ;'><font color='#053958' style='font-weight: bold; '>#{report.info_stack.stack[i].class_name}</font></td>
									<td width = 20% style='border-bottom:2px solid LightGray ;'><font color='#053958' style='font-weight: bold; '>#{report.info_stack.stack[i].method_name}</font></td>
									<td width = 5% style='border-bottom:2px solid LightGray ;'><font color='#053958' style='font-weight: bold; '>#{report.info_stack.stack[i].line+1}</font></td>
									<td width = 50% style='border-bottom:2px solid LightGray ;'><font color='#053958' style='font-weight: bold; '>#{report.info_stack.stack[i].code}</font></td>
								</tr>
					"
				end
			end

			bodyM +=
			"
									</table>
							<br><br>
							<table border = 0 width = 100% align = center cellspacing = 0>
			"

			bodyF =
			"
								<tr>
									<td style='border-top:2px solid pink;'><font color='#c51010' style='font-weight: bold'>ex) Vuln code</font></td>
									<td style='border-top:2px solid pink;'></td>
								</tr>
								<tr>
									<td colspan = 2>
									<pre class='brush: java;'>#{parsed["Vulncode"]}</pre>
									</td>
								</tr>
								<tr>
									<td><font color='#65ae5e' style='font-weight: bold'>ex) Secure code</font></td>
								</tr>
								<tr>
									<td colspan = 2>
										<pre class='brush: java;'>#{parsed["Secucode"]}</pre>
									</td>
								</tr>
							</table>
						</div>
			"
		else
			bodyM = 
			"
								<tr>
									<td width = 30%><font color='#053958' style='font-weight: bold'>Vuln Class</font></td>
									<td width = 70%>#{report.klass}</td>
								</tr>
								<tr>
									<td><font color='#053958' style='font-weight: bold'>Vuln Line</font></td>
									<td>#{report.line}</td>
								</tr>
								<tr>
									<td style='border-bottom:2px solid pink;'><font color='#053958' style='font-weight: bold; '>Vuln Code</font></td>
									<td style='border-bottom:2px solid pink;'>#{report.code}</td>
								</tr>
			"

			bodyF =
			"
								<tr>
									<td><font color='#c51010' style='font-weight: bold'>ex) Vuln code</font></td>
								</tr>
								<tr>
									<td colspan = 2>
									<pre class='brush: java;'>#{parsed["Vulncode"]}</pre>
									</td>
								</tr>
								<tr>
									<td><font color='#65ae5e' style='font-weight: bold'>ex) Secure code</font></td>
								</tr>
								<tr>
									<td colspan = 2>
										<pre class='brush: java;'>#{parsed["Secucode"]}</pre>
									</td>
								</tr>
							</table>
						</div>
			"
		end

		

		bodyHash[report.idx] = Array.new if bodyHash[report.idx] == nil

		if bodyHash[report.idx][1] != nil
			bodyHash[report.idx][1] += bodyM
		else
			bodyHash[report.idx][0] = bodyH
			bodyHash[report.idx][1] = bodyM
			bodyHash[report.idx][2] = bodyF
		end
	end

	header = 
		"
		<html xmlns='http://www.w3.org/1999/xhtml'>

	

		<head>
			<meta http-equiv='Content-Type' content='text/html; charset=utf-8'></meta>
			<title>ORROID REPORT</title>

			<link href='js/shCoreDefault.css' rel='stylesheet' type='text/css' />
			<script src='js/shCore.js' type='text/javascript'></script>
			<script src='js/shBrushJava.js' type='text/javascript'></script>
			<script src='js/shAutoloader.js' type='text/javascript'></script>
			
			<script type='text/javascript'>SyntaxHighlighter.all();</script>

			<!-- <div align = 'center'><font size = '60'><B>Orroid Report</B></font></div> -->

		<!-- write-->
		<style type='text/css' media='all'>
		/* CSS Document */
			UL.ulist {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px;};
			LI.list  {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc;}
			LI.list0 {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc; color:#65ae5e;}
			LI.list1 {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc; color:#4a7fcb;}
			LI.list2 {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc; color:#e3801c;}
			LI.list3 {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc; color:#c51010;}
			LI.list4 {padding: 0 10px; line-height:25px; margin-bottom:0px; margin-top:0px; list-style: disc; color:#ab20d8;}

		/* zero out */
				html {
						margin:0;
						padding:0;
						}

		/* basic formatting */
				body {
						margin:0;
						padding:0;
						color: #69737b;
						font-family:10px/12px Arial,Helvetica,sans-serif;
						border-top: #000 solid 1px;
						}
						
				/* container formatting */              
				#container {
						position: relative;
						}
						
				.container_16 {
						margin-left:auto;
						margin-right:auto;
						width:960px;
						}
			
				/* main content of page */
				#reportContent {
						background: #FFF;
						width:920px;
						height:auto;
						margin:10px auto;
						padding: 0 10px 10px 10px;
						box-shadow: inset #d8d8d8;
						}
						
				.classheader h1 {
								color:#ffffff;
								font:bold 15px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								text-align: center;
								line-height:25px;
								}
								
				.classtitle h1 {
								color:#ffffff;
								font:bold 30px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								}
								
				.classtitle h2 {
								color:#ffffff;
								font:bold 20px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								}
								
				.classtitle h3 {
								color:#ffffff;
								font:16px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								}
								
				.classchapter h1 {
								background:#053958;
								color:#ffffff;
								font:bold 20px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-top:2cm;
								font:bold 100px;
								}
								
				.classsection h2 {
								background:#053958;
								color:#ffffff;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:30px;
							  }

				.classsection_sub tr, td {
								color:#053958;
								font:normal 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 0px;
								line-height:25px;
								margin-bottom:0px;
							  }

				.classsection0 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;

								background-color: #65ae5e;
								background-image: -webkit-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:    -moz-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:     -ms-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:      -o-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:         linear-gradient(left, #65ae5e, #acd3b1);
							  }

				.classsection1 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;
								background-color: #4a7fcb;
								background-image: -webkit-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:    -moz-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:     -ms-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:      -o-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:         linear-gradient(left, #4a7fcb, #9ab5dd);
							  }

				.classsection2 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;
								background-color: #e3801c;
								background-image: -webkit-linear-gradient(left, #e3801c, #e9c29d);
								background-image:    -moz-linear-gradient(left, #e3801c, #e9c29d);
								background-image:     -ms-linear-gradient(left, #e3801c, #e9c29d);
								background-image:      -o-linear-gradient(left, #e3801c, #e9c29d);
								background-image:         linear-gradient(left, #e3801c, #e9c29d);
							  }

				.classsection3 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;
								background-color: #c51010;
								background-image: -webkit-linear-gradient(left, #c51010, #d58185);
								background-image:    -moz-linear-gradient(left, #c51010, #d58185);
								background-image:     -ms-linear-gradient(left, #c51010, #d58185);
								background-image:      -o-linear-gradient(left, #c51010, #d58185);
								background-image:         linear-gradient(left, #c51010, #d58185);
							  }

				.classsection4 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;
								background-color: #ab20d8;
								background-image: -webkit-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:    -moz-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:     -ms-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:      -o-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:         linear-gradient(left, #ab20d8, #cd90ec);
							  }

				.classsection5 h2 {
								background:#053958;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-bottom:0px;
								margin-top:2px;
								background-color: #ab20d8;
								background-image: -webkit-linear-gradient(left, #053958, #053958);
								background-image:    -moz-linear-gradient(left, #053958, #053958);
								background-image:     -ms-linear-gradient(left, #053958, #053958);
								background-image:      -o-linear-gradient(left, #053958, #053958);
								background-image:         linear-gradient(left, #053958, #053958);
							  }			

				.classcell0 {
								background-color: #65ae5e;
								background-image: -webkit-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:    -moz-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:     -ms-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:      -o-linear-gradient(left, #65ae5e, #acd3b1);
								background-image:         linear-gradient(left, #65ae5e, #acd3b1);
							  }

				.classcell1 {
								background-color: #4a7fcb;
								background-image: -webkit-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:    -moz-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:     -ms-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:      -o-linear-gradient(left, #4a7fcb, #9ab5dd);
								background-image:         linear-gradient(left, #4a7fcb, #9ab5dd);
							  }

				.classcell2 {
								background-color: #e3801c;
								background-image: -webkit-linear-gradient(left, #e3801c, #e9c29d);
								background-image:    -moz-linear-gradient(left, #e3801c, #e9c29d);
								background-image:     -ms-linear-gradient(left, #e3801c, #e9c29d);
								background-image:      -o-linear-gradient(left, #e3801c, #e9c29d);
								background-image:         linear-gradient(left, #e3801c, #e9c29d);
							  }

				.classcell3 {
								background-color: #c51010;
								background-image: -webkit-linear-gradient(left, #c51010, #d58185);
								background-image:    -moz-linear-gradient(left, #c51010, #d58185);
								background-image:     -ms-linear-gradient(left, #c51010, #d58185);
								background-image:      -o-linear-gradient(left, #c51010, #d58185);
								background-image:         linear-gradient(left, #c51010, #d58185);
							  }

				.classcell4 {
								background-color: #ab20d8;
								background-image: -webkit-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:    -moz-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:     -ms-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:      -o-linear-gradient(left, #ab20d8, #cd90ec);
								background-image:         linear-gradient(left, #ab20d8, #cd90ec);
							  }			

				.classcell {
							  }			

				.classsubsection h2 {
								background:#9ab3cc;
								color:#FFFFFF;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-top:0px;
								margin-bottom:0px;
								}
								
				.classh1 h2 {
								background:#eef2f3;
								color:#053958;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-top:0px;
								margin-bottom:0px;
								}
								
				.classh1_grey h2 {
								background:#eaeaea;
								color:#053958;
								font:normal 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-top:0px;
								margin-bottom:2px;
								}
								
				.classh2 h2 {
								background:#f8f8f8;
								font:bold 13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								line-height:25px;
								margin-top:0px;
								margin-bottom:0px;
								}
				.classtext {
								font:13px/14px Arial,Helvetica,sans-serif;
								padding: 0 10px;
								text-align: left;
								}	
								
				.classpre {
								font:12px/14px Courier New, Courier, monospace;
								padding: 0 10px;
								color:black;
								text-align: left;
								}	
								
				.classtoc {
								font:18px Arial,Helvetica,sans-serif;
								padding: 0 0px;
								line-height:25px;
								}
								
				.classtoc1 a {
								color='#053958';
								font:16px/18px Arial,Helvetica,sans-serif;
								padding: 0 0px;
								text-align: left;
								}	
								
				.classtoc2 a {
								font:13px/14px Arial,Helvetica,sans-serif;
								padding: 0 20px;
								text-align: left;
								color='#69737b'
								}						
			
				</style>
		<!-- finish to write -->

		<script type='text/javascript'>
			function toggle(divId)
			{
				var divObj = document.getElementById(divId);

				if (divObj)
				{
					var displayType = divObj.style.display;
					if (displayType == '' || displayType == 'block')
					{
						divObj.style.display = 'none';
					}
					else
					{
						divObj.style.display = 'block';
					}
				}
			}
		</script>
		</head>

		<div id = 'reportContent'>
			<span xmlns='' class='classchapter'><h1 id='idm331888'>Orroid Report</h1></span>
			<br><br><br><br><br><br><br>

			<div align = right><script>document.write( Date() );</script></div><br>

			<body>
				<div>
					<table border = '0' width = 100% align = center cellspacing = 0>
						<tr>
							<td colspan = '4' class = 'classh1'><h2>Summary</h2></td>
						</tr>
						<tr>
							<td class = 'classcell4' width = 25% cellpadding = 10>&nbsp;&nbsp;&nbsp;High</td>
							<td class = 'classcell2' width = 25%>&nbsp;&nbsp;&nbsp;Medium</td>
							<td class = 'classcell1' width = 25%>&nbsp;&nbsp;&nbsp;Low</td>
							<td class = 'classcell0' width = 25%>&nbsp;&nbsp;&nbsp;Total</td>
						</tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;#{high}</td>
							<td>&nbsp;&nbsp;&nbsp;#{medium}</td>
							<td>&nbsp;&nbsp;&nbsp;#{low}</td>
							<td>&nbsp;&nbsp;&nbsp;#{high+medium+low}</td>
						</tr>
					</table>
				</div>

			<br><br><br><br>

				<div>
					<!-- subject -->
					<table border = '0' width = 100% align = center cellspacing = 0>
						<tr>
							<td colspan = '4' class = 'lassh1'><h2>Detail Information</h2></td>
						</tr>
						<tr class='classsubsection'>
							<td width = 10%><h2>No</h2></td>
							<td width = 80%><h2>Subject</h2></td>
							<td width = 10%><h2>Level</h2></td>
						<tr>
					</table>
		"

	footer =
		'
		</div>
		</div>

		</body>
		</html>
		'



	fd2 = open($path.split("/").last + "_report.html","w")
	fd2.write( header )

	bodyHash.each do |k,v|
		for i in 0..v.size-1
			fd2.write( v[i] )
		end
	end

	fd2.write( footer )

	fd2.close()
end