<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PaginationSQL._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
	<link href="Styles/screen.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<form id="form1" runat="server">
	<h2>Artists</h2>
	<div id="artists">
		<div id="pageSize">
			<label>Page size</label><br />
			<select>
				<option>10</option>
				<option>25</option>
				<option>50</option>
				<option>100</option>
			</select>
		</div>
		<div id="pager">
			<ul class="pages"><li class="pgEmpty">first</li><li class="pgEmpty">prev</li></ul>
		</div>
		<table id="artistTable">
			<thead>
				<tr>
					<th width="100">ArtistId</th>
					<th width="400">Name</th>
				</tr>
			</thead>
			<tbody id="artistList"></tbody>
		</table>
		<div id="loading"></div>
	</div>
	<script src="Scripts/jquery-1.4.4.min.js" type="text/javascript"></script>
	<script src="Scripts/jquery.pager.js" type="text/javascript"></script>
	<script src="Scripts/jquery.tmpl.min.js" type="text/javascript"></script>
	<script id="artistTmpl" type="text/x-jquery-tmpl">
		<tr>
			<td align="right" valign="top">${artistId}</td>
			<td>${artistName}</td>
		</tr>
	</script>
	<script type="text/javascript">
		$(document).ready(function () {

			$("#loading").hide();

			var pageIndex = 1, pageSize = 10, pageCount = 0;
			getArtists(pageIndex);
			$("#pageSize select").change(function () {
				pageIndex = 1
				pageSize = $(this).val();
				getArtists(pageIndex);
			});

			function getArtists(index) {
				var query = "Json.ashx?page_number=" + index + "&page_size=" + pageSize;
				pageIndex = index;
				$("#artistList")
				.fadeOut("medium", function () {
					$("#loading").show()
					$.ajax({
						dataType: "json",
						url: query,
						jsonp: "$callback",
						success: showArtists
					});
				});
			}

			function showArtists(data) {
				pageCount = Math.ceil(data.total_count / pageSize),
				artists = data.items;
				$("#pager").pager({ pagenumber: pageIndex, pagecount: pageCount, buttonClickCallback: getArtists });
				$("#artistList").empty()
				$("#artistTmpl").tmpl(artists).appendTo("#artistList")
				$("#loading").hide().find("div").fadeIn(4000).end()
				$("#artistList").fadeIn("medium")
				$("#artistList tr").hover(
					function () {
						$(this).addClass("highlight");
					},
					function () {
						$(this).removeClass("highlight");
					});
			}

		});
	</script>
	</form>
</body>
</html>
