class Dropdown
!!!175362.php!!!	__construct(in dropdown_select : string, in dropdown_others : array, in Tete : PageElement) : void

		global $config, $lang, $Visiteur;
		$this->setTemplate($config['path_template'].$config['dropdown_path_template']);
		$this->setFonctions($config['path_func'].$config['dropdown_path_fonctions']);
		$this->setElements(array(
			'dropdown_select' => $dropdown_select,
			'dropdown_others' => $dropdown_others,
		));
		$Tete->ajouterValeurElement('css', $config['path_assets'].$config['dropdown_path_css']);
