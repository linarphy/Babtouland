<?php ob_start(); ?>
	<div id="conteneur">
		<section class="ligne">
			<section class="colonne">
				<section class="carte">
					<section class="contenu">
						<?= $lang['user_statut_nologin'] ?>
					</section>
				</section>
			</section>
		</section>
	</div>
<?php $contenu=ob_get_clean(); ?>