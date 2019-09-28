<?php

$config['css'][]=$config['menu-up_css'];
$config['css'][]='assets/css/dropdown.css';

$config['javascripts'][]=$config['menu-up_js'];

$Logo=new \user\PageElement(array(
	'template'  => $config['path_template'].'core/menu-up/logo.html',
	'fonctions' => $config['path_func'].'core/menu-up/logo.func.php',
	'elements'  => array(
		'titre_lien_accueil' => $lang['menu-up_accueil'],
		'src_logo'           => 'assets/img/icone/icone-transparent.png',
		'alt_logo'           => $lang['menu-up_altlogo'].$config['nom_site'],
		'titre_texte'        => $config['nom_site'],
	),
));

$DropdownLang=new \user\PageElement(array(
	'template'  => $config['path_template'].'core/menu-up/dropdown.html',
	'fonctions' => $config['path_func'].'core/menu-up/dropdown.func.php',
	'elements'  => array(
		'dropdown_select' => $lang['lang_self']['full'],
		'dropdown_others' => $lang['lang_others'],
	),
));

$Avatar=new \user\PageElement(array(
	'template'  => $config['path_template'].'core/menu-up/avatar.html',
	'fonctions' => $config['path_func'].'core/menu-up/avatar.func.php',
	'elements'  => array(
		'lien_avatar' => $config['menu-up_lien-statut'],
		'lien_titre'  => $Visiteur->afficherPseudo(),
		'src_avatar'  => 'assets/img/avatar/'.$Visiteur->afficherAvatar(),
		'alt_avatar'  => $lang['menu-up_avatar'],
	),
));

$MenuUp=new \user\PageElement(array(
	'template'  => $config['path_template'].'core/menu-up/menu-up.html',
	'fonctions' => $config['path_func'].'core/menu-up/menu-up.func.php',
	'elements'  => array(
		'logo'             => $Logo,
		'liens_grand_ecran' => array(
			'liens'      => $config['menu-up_liens'],
			'titres'     => $lang['menu-up_titres'],
			'items'      => $lang['menu-up_affichages'],
			'type_ecran' => 'grand-ecran',
		),
		'dropdown_lang'    => $DropdownLang,
		'avatar'           => $Avatar,
		'menu_petit_ecran' => '<a href="#" class="petit-ecran-menu"><i class="material-icons petit-ecran-menu">menu</i></a>',
		'liens_petit_ecran' => array(
			'liens'      => $config['menu-up_liens'],
			'titres'     => $lang['menu-up_titres'],
			'items'      => $config['menu-up_icones'],
			'type_ecran' => 'petit-ecran',
		),
	),
));

?>