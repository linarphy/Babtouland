class Page
!!!176002.php!!!	__construct() : void

		global $config, $lang, $Visiteur;
		$this->setTemplate($config['pageElement_page_template']);
		$this->setFonctions($config['pageElement_page_fonctions']);
		$this->setElements($config['pageElement_page_elements']);
