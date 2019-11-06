class Notification
!!!175746.php!!!	__construct(in elements : array, in Page : user\page\Page = null) : void

		global $config, $lang, $Visiteur;
		if (!$Page)
		{
			$Page=$Visiteur->getPage()->getPageElement();
		}
		$this->setTemplate($config['path_template'].$config['notification_path_template']);
		$this->setElements($elements);
		$this->ajouterTete($Page->getElement($config['tete_nom']));
		$Page->ajouterValeurElement($config['notification_nom'], $this);
!!!175874.php!!!	ajouterTete(in Tete : \user\page\Tete) : void

		global $config;
		$Tete->ajouterValeurElement('css', $config['path_assets'].$config['notification_path_css']);
		$Tete->ajouterValeurElement('javascripts', $config['path_assets'].$config['notification_path_js']);
