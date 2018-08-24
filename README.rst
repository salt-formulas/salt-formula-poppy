
=============
Poppy Formula
=============

Poppy Ergo Jr is an open-source robotic arm based on modular 3D printed
conception and low-cost XL-320 motors.

Poppy Humanoid is an open-source and 3D printed humanoid robot. Optimized for
research and education purposes, its modularity allows for a wide range of
applications and experimentations.

Sample Metadata
===============

Poppy Ergo JR

.. code-block:: yaml

    poppy:
      creature:
        enabled: true
        name: ergo-jr
        kind: poppy-ergo-jr

Poppy Humanoid

.. code-block:: yaml

    poppy:
      creature:
        enabled: true
        name: humanoid
        kind: poppy-humanoid

Customised Poppy creature

.. code-block:: yaml

    poppy:
      creature:
        enabled: true
        name: customised
        kind: poppy-ergo-jr
        source:
          master:
            engine: git
            address: https://github.com/poppy-project/puppet-master.git
            revision: master
          monitor:
            engine: git
            address: https://github.com/poppy-project/poppy-monitor.git
            revision: master
          snap:
            engine: git
            address: https://github.com/jmoenig/Snap--Build-Your-Own-Blocks.git
            revision: 4.2.1.3
          notebooks:
            engine: git
            address: https://github.com/poppy-project/community-notebooks
            revision: master


References
==========

* https://github.com/poppy-project/raspoppy
* https://docs.poppy-project.org/
* https://github.com/poppy-project/puppet-master
* https://github.com/jmoenig/Snap--Build-Your-Own-Blocks


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use GitHub issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-poppy/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

You should also subscribe to mailing list (salt-formulas@freelists.org):

    https://www.freelists.org/list/salt-formulas

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
