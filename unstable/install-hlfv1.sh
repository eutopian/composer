ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.11.3
docker tag hyperledger/composer-playground:0.11.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,��X��rO6�ţO �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�o��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c��Q!����'@xpJ����ϙ�V����;�m�̿p����矍�x!.`�/�����[<�.�P�HC�;�m����P��OS���C�?&���Y�T+��ẇ+�����s�D�"g�!��1�oZ~y0G����������6�����s�ߔ�.�·�mC�6�������"��?�rHDc���G7��Z o����Yf [,�wa&̄/uڷ5Z�B�l� ����<�p�z�8?@˰ж�5��nd�0]o�|LK���ѱ\H�d��֔S���T�6鑈��C��хC��k^��f(]�#�]����+���.�x����	u�mUԱ���ji���;Y��Z3$[JG�\��j&���`a��"8I=��@z��Հk�k4����$5ԾT�,6̏�H^z?'1�3*�J��7抺�(�/n�����&_�k.��8_�sL����Ρ5A���u@����l偖��8p:����em��ч(��uUo_��q!�1�/��u��=�$,L�~}I�-�[��,� ��4>��U�HA�c � ���Q���� |��"�a#��i�e�@�$5S-5�M6.[�nl��;9j~�f� �P�{�G13@#8j�+�d �b<b
��k�}�&�m1�^��V1���
2hƝ�d>�w`��y�8G"3oU�<��}�/i�V����6$_���>������ю6G������\�!�0�M�:4PuX��ч�ml�A����t�A,�3�)什��0'�����?���1�qc�Kʯh�U���W���qz����&���3z���D�^а��}��q��1�74�g��P?ڲB5n��/�������au�2�������l�#��s�@m,�������n����NJ_�_<���l����iS�c����v�����4ײpHk �ǰ�T:W޻�:�����Y%U�V���t�1��|ˮ���� _mc����DVnFL�s���T��J�WW�f�o�N  ��nC�Gd��n7�E� ��&��:�lxs��F��~>����;�Yz+U�\=��
R�V���	�y��xaC4YM��L&Jﱂ�lZpo���P�ë�$*�x�<������s��xKB��I�Ed��@w{h������,,.��dAG�t�V�d���舯�|g]��f�BOr��,bs���v���ȸ��+��l�������a��O���� .��(�L�qa��xx������{��=��hB4�B�[����1��ʾ�:��9�?e/ݿ���?�L�����?��0��=�`����?`�1��o�����=,x��ǅ)����g-0��W»pCG{p�v �,�����;��^O֛v��;�����	�����t\�|�#u�~�ľ)�cm� �Bt5'�3�Px�Bd2�n���6W)�	�ԝ SdԴj� E�����_b1u�B����G������y50:�FY=�Z����\c��_�����"?�-w}�!�������������t���\�=r��?t�hG�$V�I � ��Fz��t�ث/<�;{�;��!&̆�Q)��҅n������gy���g��.:%�\|��xT�Ep�TcݸV���,���5WncA�?�3�!�l����O����V>4���]����ς��?�3�����_�뿷��;WD�ǁ@�� ��QI��ȶ !sE(Ev�O?��?�J�5
94G�'w���N�� y�;�Y�ڙ��C3Y���k�\r��P��c�m܂�N]!���~� ]�zw>��cYu��wb,ʌ�z���`&�2)�Bc:
2�-c>1XG�ABݟ���n:BF��
���5V��L��˶���c��0������_�
��+���9�x��p�GM���XSu��]�w��`���[�pтTHJ�J��:K�g"�O*�ɼ����<��&s;YX3�#�!wMmRX�)�)N�)Q�!���RY:;���N��JE�UKi�*���� Z��z�>,��=WW/���e+b��/Ga�	ɗ��\1{���R~/-%kٙ�s�=4"3ɇ�3	�!&l/0�xR�bWW��W���H�Z9W=���ʥ|���Φ�4���Y��{���٫��]�QEؚ�w�>�jc�; ��m[���k�Y�Fz��,����q=�hw^���U�wZ���c����m���>{��=��*H�p����ZBM
�S��|���mf��V�05�`��;�+`l`�Ā�Ƈ.�Q?�) ���Ţw+��^�W~�����?{�(�%�?���w����&���a���ϥp��?�M�4*����\���5��4䇇��(�]V��|KH��:��xup �lI7�-{���o�\U�`#v� �<�?u� n���W>5'n�S����>�.����X�\������k��W�?N`���kX|֢�����J%���Wk�p�N�1Y�N����R�E�?��儍�������ArKUOmw��G�G-m��|	F���}/�o�'�|�۬�k�����\��l�ǚK�V��!@ ����o�7�\��s�����=x���\)x��1�g���{0�g����k.��+ӯ�L�;��A>�r���|De�m��Ϧ̍���F�T(E��`W�Z������	<�C�1�x������p��,���4��X�������/k����Z�y�)�\,jcQ���O���������k����������������<�����6���NKa�OȭF�Wv�X���x..C��|�O4Q^����H�����5va������+j���ֿQMSS������[���/o[O�}NQ)C��Q��ֿn��5ZĮӿ����.'��~��DE�����a��_����آF����(�ǖ� �����S��O��W����@����_�rD~�Y�V�b�����?�l��z���?~�o�6�nv�y!���k���+���x��6Q�x�A[y���H�-�Pe���B�k8X�8ө��G�V���#g�PX����F�Q�;Qf����-�o�(	���(+�v�2� �Pdv'.'l\�2�85��k�H+��^pwB�R6W)�\�er)�*���z!�Ke�S)QI��A.)�se���z�հIf��۸jH]�h�j������9#!܁r)�Qb7+�5)�)���t)���bUUMu��FV�5�o\�X�Ȝ�5/O���(OMf��J/�p��	�s���o=�*e��K�=}��4�&�ӊp������({8���;��|o.�`��UeP<�q�j�)Us�1N;'i�(��~|�l��A��$]?:�J�7�ڥT-��ýK%G\Ɩ�O�JO0O��q!y����P|�׸���N�'�¹��x޸�Z�$C0�������ǂ��B/Tf3�����b�QM���L����J�O�m)�J��Ҿ���d��9�H���E�Z��~��V=98>�X��q��&������V��N�� #7+�*��Ss��)V�9��<,�Nyi�mΫ�d� �h.���@JFGx���i���z�\H��I<�B�ƽj�G�B�@�%{֩�Ɠ�d�n����A�W��$ '�J���
*�F�G\�Dc�34�)�i�����x��(�^OI�_���ȗ	�8�觯�� +�qmPO�S�H;׮1�W|3lC2e)7($�n���^�?�u���~�X+�{�u��R1=G諫�p$�%o����?V\k@���~�/�zwC�m�ecL�	�?=0���a8��-���������~��S�}k��������(�
��k���tX���� ����*��hMo[��Yf c���0�A>�<0�HB�6bO�ӒXg*�[X�kZ_ˤ�rY>8�9��L��(��~�>��f�ֽ�ȩ���:�Kiƫl?��z�6<*C!�A�V��j;�9�k��VK�dE��k�0�ޯ2����QH=��+�l�>��>�y�����/l��u�'[��Ƨ���|�?7g��7��������R��?�H��}����Ʈ��x���ڢ$���I��j�M���Fl�i��a/��2J��L�+A�-��u�r�c�Q7ك�|��ѝ�.ؼ�.�ľ���99-�����4e�z�~?p����KZj;<���`�������!������a-=�Kп,3DMe�f�2$|�S�p,�a�m(ｯ�|�-Z�`��r�Ax1�p�j�K^R�j�4�4l��J"����u��8�mГu����șo��I
ЃO�?l�>��G�;�r�Z  m�dU���*���m��	2���G4�fHV5t <0�H�RF7R���a;:�w��G�]����<4�(y,�m��ʼ��kΝ|l�}��k:��q�N��t5~I�rC���\8�Au��YG&�pV04\˯�[�]��U����w51�y=�Fa�$�ۗ�Uh&��L���o��I�v��������aT�n�{�v{�m��Փ�v�q₄�!q�$$�+BB+��{�U�n{<o�̓Ce�]��U���U��*�s|j"།v<�`����I��@�K���F���7�#L&`�
D��^�DSLț�>`��@e��$�l���B�]}�xC�H�q]9�jpz��X���(D�9i������:� �'ef����MП� �d����}	0�h2>��g������a�������;�:��5�]����w��?~ 9#���+��wKh�,�v�)l`obqeP�}�h�%��
�e~NNs��L��6��v��{�Ӵ��)��܃)�`~��{�FS�:���^�~Q��d����2�EH�fk�$0�$}y������/0�3����uB!��5%xk�?=���`���/\�x�_.j�n�W(P���+�O֘����7���:��J/Q-��Q�'$�LO>w6��9���#Y����!O\vn3}՟�އ�"�dM�]��T���O�T�l@��m#ޒ�C$t��pjM�@�Q��Sj�^;��R2����5��M�t��EE���a�,)k�lh�!S@vQ����Õ������=�q�ƑN�:76:ڍ�~H&����@�Vŗ9=�򨛞?��0�?uj��n�����@\�ȷ���E�L�zc �X�N����{�n�F]3��=�WUF�C��~݉XW���x,�ؘ�'����?����KN����?��?��|��?���|���/��������)�)�7)bA����￾���_`���hG6>�B�?�"�%2rTR⽸�$b�H<�z�d/I�㽘L%� II���H�3rfH(=%.��nh7��O�z���~�|�����������L���+3�[���ЯGB����
Yk�����?����a���p��{����o��_=�˃�?=X=����mG�0VC�1e��jlQ����澥3%a�5m���U=��*�Z��Ϙ%X�EXy�*" ��L���jہU\W`�5�v���	i%gG��%��sᬖ�: �-����Fa�]�E��i�X��9M�9{̶[�qg�YHC�/��v���
�M��	q�>*��ay܍�gB}`�lLp�����4<��[�-��v4c	u�Ϋ��%�y���Hl'��Z51�A��f��``��ˣ�ʥ�~�6�N²����<��V��7ٱn�E�*�Z�^�HD�˕g�ܞ)�z3		}P�	��͢j�#U�V34�{5?�4��|��'��A۬��E��i�}���uV�s�ZS����S&��7�sp>$:ń�7��Y�?1��h����0E�Y�i^�.&ga�yf1m���E�3i=���J��d_ǳ��e�ˣ�T�����L$���hZu:?Jӳ��+sk09�Ǌ����>6����u���k��.�K��K��K��K��K��K��K⮸K⮰K⮨K⮠Kb��
�`�%�l�h�-�7�,��ZEi�����n����T=Ü-�d�܉���hq��D�O��j΅���/	�{��z�(ڷv=�=�s=i�  ���杈T���!<�s��-���(Rϧ��؜���;T9fi�NKlv��,��V!:�%9jF��"����'�&�w�.g�'*j�m�������ϋ��TǠ{�Y:� "��ʳ�I%j��B�gK��d>i���s�R�S��x�BS.�I*�0�Pv�d����[jF[$bV1M%Y�>)��������+G�Z��iV&�*!Gz,�z��p�N�+�l�ݛ�Y���v�v^=
�ނ�������h7��sx��n�#��-�Y���ì�.���p~X5t��}zg����Kv_ل]N�=���_�Ph�������
\�-��G��8)��B?�&x���o���>�����<����%�ٵ�����L+��[�YE45�ʴe.U?Iʽ��ė��s,��|~6���];���H��"n5�yz���M��\�c�j6���˶6-���4=\A�7�(Di��Ȩ]�Y���qc#Hf-�Y�B�YR�Bj��&��츪��jD&Y��fGrfH�+�/���0R�hG�n��%�k��5��i3�k-O�������A�m�D�+��Ic��2h{I��i3j�C�i���F��1-��,2��4&� �[5�������������9�@���5�~��ۃ%}D�9J�\�Y��5Z;Q��I^��~s8<�"�r��N*0�P#	)\3����%`�
REG�ۣ�}f��㺲ߙ�J-��wyAo�'>�\��ڵJ�E���ʵv1���aM��J\�T1�i������/��7���i3@�-�c/@f���	_���	+r1�m/�gܢ�e݀i����i��W�ԝ���{�N���n�Ճ�_n ��i-3N���bly&[���U��
�j�m�MqZ>Ѩ��K��AK�5�Jk��q����cׇ�'W�5�J��Z�l��d�}^.��Ņ+�@�N��9�rV�i��Q�3&[�y�V[ù�0�Z5Ϋ��|���~��??�s:��Q�y���|Q���a���iL��'骒�+�Bk 6�1Wl�fE���x{�;W���"T���|!�dϥ�^w��-���S�b��D�l-a���ڳ����Z�(�ȑ,V�D(φ���DKM*Ô�>�	�[b_�#1�<�:�y΋u�K0B��΄����L�U|�3p:�9�:
�=�B��;�Fq�5��G���U��&��֐�L�|d0�&�kEӳN���Qn�/�)�әF�N0V�*'�f�8��c�2=�iDzٟ �r[�Bxe�CI5Km�<����GK(T��5�8j��3%:�b �BAܰ��Ca����H3�/&j�|J%���铓̼JφD\�&�h��&�5À��vd
��-0ɹU[F:\������2�
�W����Kc���q�#���wC�C�`&/��y��l�8�D�� ���3�B��$ވ���/�X����Ds^��v|�_!~-�*#sj���z?��i�O�G�<.��-�����;��_~�%��_�~�V�z�q�C��Σ��"4�,>�<h§��x�A�L����΁�����	�~�}m�Һj@�����k2��>%~�f����s:�����y�'���Ρey���b��]�C�|����t.�Ҥs���C������֟[��Cx"k~3�/�\��/��]8�!�~���U|���\��/���'��&�_OIV��|����;��� I!|l�L�!1z�L&cV�$�`����uN��F�� ���b_v���3	�6aMsl�y;�6�M_%��w�sH~�>aT��FP	�K��X����z���׬�Y.�l����R] ����/�[*q��\�,p ����Z<���5�$�p���HPP�!��D�tFA�G1�0E��g�Bm@��	B�������!f����o�0\$��w��I�M'$�[��7��L��P����a헧������ ��z�B�al�K��p�{�'[T�c�?��;��9�4\�+�`�6>u�A�3E7����ϳ��G�p�Yd��M�+�b �V��g}�(��d���mŦɹ.d���4��m�/dm���V��ڦ����|5P3<4��
���{H�0�\��E�$��@�au�����d݀�[&�U������D�����1�~�lJ}a{sѻ7o�P�h����`��~|���]������4A�_q�H&�iⳞU�E�c��#��C��.6��Q�#Ѻ��n���7޼Āc�-4Ren�qsć�����S5��I|�ˊ|���t��qq�x#���\�'a|<2��͘`f�Ö�ݒ5Qt�l]\��m�H�7��w��L����U!�����}�Q��z4�ٌs:@�=�谇1�{� v�ᔀH����v�:��f�^u�2鮕8�C���F&�z��CI�j�P@J(/�\p9$��:w�J�⬑51ts|=�U�7JanX3���b�y�y0''o3;sm8n+ �+�!l
��j�����<r$X-A9O�oG�2
ّ��~�\	Q����[M ���D:l����b+�KvΤI�	֮��/��e�zc��K�I{�0���c�-�83���wK�Ht8P����1Y���m%��+�$�(y�J���a�dfb�{��5�kLCJ�<�����eo�+"w���$_=D�C#��zl╵a��h
ݦs@f"���R7繡�WE�_t��,�c4ewBii�'"(���1Xwmqpc��b��d�ڍ�H���7�c�����|5� 8C$?�6#���������^x���8זq���D*�Z���:���>���|P�c��4�)A�!�u��d˝������4D��6Z�h��gO��)��YX�����A�%c��su��LC[jK||U.��,ǗnP�jں��):q�`�\S��~�r@4*�^,��� H�T&��DL�%z�d��Uz���Q D��?�����$A<�V@4	Ńcɐ��n�CW�8���4�2��ɧ]����8!/�����KCn܊-���9P/ƒ� )� �$E��HJ2U���  ��xFIE�ɴ��� 1(�tF��
$�C>����߱M>�?�Ҙ��m��u~��s�o���[�N��r�F1$�61ؚ�5*����K��Rg�:�y�����i��/q�\陬HS�r2�!re�e�\��,��ȥ����8�Pa����kH�뗷vɖ�+��KB�ʳ�d�Q���.Tah���.���X ��d�2Z�	c+�he-lN�aU��S	�������[4M��㖑������.�yE��D$���nJ��}�d���b9��1��K|�R��(����i���#?�h����+JG)X�i��I��S��V+|Y|6i��p8��Z�g`�LGnxu`(Ή
?�C��� ��n���.m֍�d�`�B�!f+��?-sb�R?`�yztܷ�^��8k��`�ýJ���J�*�k˪86�6DZ䜿,-����e�m�,s}����/{W֜��l��+�;u��[�U}� !��҄�'	����`H����N���!&hKk��ݽ��)������.��0UN����~�n���^^��ǫwm���ȟ���a��E������S��&�����?��������������l����W+���r���o��u������Ͷ}���[��FOw�����}?盻�z�,���z��#M���4ϟ�|x��/��%]�������}�o��s	�^1��&���P$�A�w���z�3^�����4�����o_��~��34O��� ��u��M��7
|�������P �X�7�?O�#�OS�s������x����|"P�e��@��?9��8����G��������3E?ҿ,�wg��?$@���H��Q�(&Er$�u��"�`�pa��$�T�")����&X1�(�X��M?�����!�gx�V���/$�F�=����?�Qi0Yf��j�w�Q�uG�r��2�Hʻ��q�������ϸR6�~�уt!���p�-]&����#�α���dJG~���4<�3��u���6�u��yM�1���d������ٟ�����a���q�x�()�{����%�O
��G��&����@��?(,��z ����7�?N��Q�`���i}	>5�����J�����G��ډ{)�,z ������<�?
���W��B�(:������4���� ��9�0��.�|��ԝ�O��@�_�C�_ ������n�?��#�����C��Q����?
��ۗ�?^|����Ak,�n)�ץZ̥S7Wn�?O�����z���^Z?���~^^#̚����K�'���<�>�e���ϧ�Obf�?T4q6KKƩQ?*������T��,�n��A�2kl��z���L���v�S+�b|�T��Cm�}\��������������Ϫ��7B�'5:�w]y�o�W������1X���l4^o��}����<w��2���̈�$ιSi�t�m)Y�j����h�ը������YG�.Ey��n�Ͷcwu��b/u�[� �����wm�@1���s�?,���^�.Q��E�������H �O���O��Tl�G�Ѡ�P ��N(�/
�n���?���?��X���7A����!������b���_������a&�x�Ѱ�6﮺��%����q�cX�{���T�/���5w-��a@�`�Gun&� �7�����U�.�d�᭥|!4J9�4#�)�$i�rS��#�5T������[���װ��>��eSίq�������7B���ڹ���;�'���_{��a�6�r��еM4I���O/cm/��9���(V�j�Uґ'r�{`�|w�ʬ���󊩞�+9�H#CR�'�zfoa��@��X�?���@�� �o�l��!�/ �n���3����#N��JG�$OE���ȑ�$1��a(�!�3>/�4�$�!�HL@�$��u������!�G�������^cz�(�v�R�x"]��~{��,��}^�V��&	����-���ܳ��>�ǻ�Iz�=������p������m���j�X2j�n-I}�in�M���*
��K��n�9~T������?�C��6�S�B����_q������0`�����9,�b|B��������,[��zi��'B�;�3��Ļ��V�Sϛ�����S��7���Ԥ]��uL�����U�9���(w&��<��%d'Ik��ܞS:�s�6ڕ�N��y���.���<�������oA�`�����xm��P��_����������?������,X�?A��gI�^�������;a��*��n1���'�ax��M��?�ѓ�e�I����g q}�3 �o��� g�V{�p*�U��e��3 d{?Z��!�K�l�4N�%=#g�vD�K��Ҩ�F���:�֩���.%V��Y�Jg��@۪�\�����N%+[.���D��w�]?y�
����U/3 l���r��J�W���$��+�h_����[�}O��:e�z��Db��5h1N+�X���j�Ё`�cS)���2�F~�i�Po��4ʦn���k���n])�Ѯ~
��pب)��p��%��G�M�]��VS�(�X*�Ϊ�=�/ϳ�ʬ��lc��<9(U�g�zc3��n4�A�Q��ǂ�C����C*<����������x�?P ���;�?���H�<��*��E�N !�G�������b��(��/H�%���A��H
�Qt̆�/�����ȋ1��e���t$J1+Ĕ��14v~p�����r�� ����Z�nv2�.7\��.Mp����d��Y9;�6=��[&��������h�`�����ة�ZU��mj⾔w��QZ��"�Z$���֢���s��G|gW3]�����*�^��m�̢����?�ޙ��$�x��X<�-?��C���i��� ���������-&��#����������A�" �����8���_�����������P�Z�m�Z˞U:Fe�z\��J������TH��&�O��:m����~_^#�S�}9�&~Z���}����>'�?�V<�����Nl���N�쭚{�L�����xmL�;ݺR[6g��0︣�ߐ?r&�<�[�h9���Q��{�~�&yc��*MSf���,W{�z��m-�^Qέ,���C��m�9���z�ġ�Z[R��愮s5��w�Uىl�j�*�6l�P�dt�1+�'��K���+	���β��=i�F��H���V��*+}��FnJ��!=�����Qe%aYnGƺ,p�g�����q���[�����e�ׂ����7��ߩ��i��C����o����o8���q�/�����n�����q@���!����������( ��������[�����o�
|���K/����	��������	p��$o��P�������?����B������p������G��!
�?����ݙ��H���9j���_�`��	������.�x���M��?��!��ϭ������0�h) 8�����@� �� �8��W��s�����X�?�����!P������H ��� ���Pl�G���#`���I��E��ϭ�����{�{����H��C�?r��C�q�������?:�����G��C��,>��jC�_  �����g��0�p��:����>�� 2�8�x��J,����b��'B�_
(��%�e9������8�?�S��o��v��#��i�ç��Z;G���"P�J��%7`�	Iy��4V��4�<���P�ت��������Ӱ��nܑ-U�;۽�ڮ�Y���T�U�t�u�*qB���{�;ܑ��c�����$Q����Z��-:��P.k����j]2^Ċ9^������K}�1�?�����l��������C�Oa���>��sX�������!�+�3�k���JY��WJ�ƚ�J�Q�֦��ԩ��f�j���֗�c�׍g��s�̶֩J]z��d����`L�n�I|�cSv�;%�v���p}�ʛ����-�^��d�N�,����Y��x��7��!������O���� 꿠��8@��A��A��_��ЀE �w~����A�}<^����_���S����-�tv:݋Jb��r�WI��{�vi�)��U�u0����x�1릻���a���g҆g��p$d�b�H6��QK���4�T���y����F�IS~*�N��1�e'̈́_�'����VjVW9q����㕾x�]�N����nE�M�|/l�D�(��<�M��f��˵r��c���)Z R�l[���"1D��-�i��6��f�P6u[5j�!p7�f��43##����84�����R�9��D1:����R�_T���Y)�dz��k��6̬<Z�9ac����x'���Q�}�<��W��Ҥ@����I���_$���>�������O����������o$������%^����:��$E�� �O����/��h����<=�*������<�w��(�R��ꪪ����~a�����3)IiFc�1oN��@���Mv��?T��a�*�>dܴ�z:+�o��aV�kʏx�܏���5�g�z�x�g�S���$O���%uy�\^\K�omK�]��$�c��P�f]ME�/uN}��n/l��R�ϝ�N��Ƽ�Х�^%gk]M�Q����	��J�5��e�ZeNɚ���]w�W��I��'�xoW���r��V����7�t�;?/k�$C������q}s���]+������Ğ(�"��awÔ{�<�~Lu�en'�}�fs�iLBmK�|֬u�e��&k�.Ozܜ8�B%l���Î�^_���` ��~A�s����SJ�D��e_ɝÐ��� 7���'���;?v=/�KNK����7��,�wS�翈�F�	G<���0)���R��e����$͏F��2��g�������c2�"���(���������!�����d$׼lg�'�< 	݋��^����]\?|�3F=������V�|�V��ȕ�Z����⣟�K���?�%�������[��?$@��C�c�X���m��	^��5O����5�gd��M'J[�-]��h����.��_�W������.	6�m��ٗr?�=��K�xE�o`*�S����{J������$sj�r�*��ޕ6+�m���
�^ŋ���� �vtu  8�CGG �
"������̛�U����t����"e����{���yZ)���!��H���CsYs�N��dm�(;.�[8M[�Y��=��8:.H6�����ˑ}e��!�:�w�C����pv�E-��R���&R�펕��>�[{�����m"���Xgf�ֽ���#{�3�\ϺI�ba���Cw=�u�����u7>��&�ڜg���(/^k*����f�'���?���E�Ľ�������J�n��*�U�*A�3~:����05�Rq��V�d���e����d^�U`���������*��o����s�OlЮ/�F[��Ʊ7B�5anl��#9�wu��i^o8/��/[RՂ|�l���[?����7��1�Y��/Q{�����x�մ�Vx,$��������������
����������!��_���S����������������PmuCkon�����0ns��������♝\�}���j��|� ��Y}$T�����N�����l�m�e[�öx�Zי+�[���3W��ҕ+v�ryma,���fߗ���y��pV*��2
��؋���z�\
G��dQ�{�����z��Ǿ1=��:�p��-⁻�����r����Z��K�N�-�w,���Ɨ�����|�e��e�g���X޲��=����%6�kc�����5-^n�Bp�<�xIi�Xu���Ͷ�}S�U{���Jc��������pS�]u�h��`0b֪�ȪԐ�5�pd�aM�;ő0���Z�p��}j[U�?�}�_F�~o�o���Y���
�Q��c�"�?�����H-
���2�g����O����O����V��s8�?��+���~Ș���`(D�������L �o���o�����ޢ������]~Y|�>�'1���A!�����ό��ߤ�C�P �����w�a�7����`�� ��ϟ�	�&���y�?�B������������
�������?���l���L ��� ���B�?���/�d�<�����[���+7�������P�
���?$��� ��������A�e���"@���������� ��9�����C��0��	����������� �?� O�:�����[����;����	������
�C�n��������E!�F��ON�S���Sm��� ��c�"����a���P��i�L�2KJ�k$��Kͬ���ҬT)�`����n�ZMM�P���0�Bc4�>|����"�����!�?���{y��E��0���R���͵%�m���-����Xhp���@�o���5�s��յӈ�#�ءU��7	���	�k�+:`�6o�t�z���n� N�|\&��n\х��$>Y#�X*$v@遪p������%
�{���*3����U�͓��jk��+��x���n����?�懼��h��E@����C���C�����$̻E��������8�j�^�):�0$f�带�4�X�f��}$���|x����d�]v������v��D��g#���=�G89l*U��3�FEGwMs�TTN�V�HZ/w+e�Kb-��C�\��}-���W`�7'���������7B!��+7@��A����远�@�B�?����_���߳��~�ݎ�Z[u`�'�$pC�����8�����%�9�[H�����t ��|�y=��b2˵��i��0�;\D���n��6Yv5oVf�q��gf<-�3�ȹ��k�$�
3�����koԥ_Q��^�ǠG	͕V�vm����K��U�ȶ�.���p,\�&+�,A��z��L!�s\�H��:��G�"9ND_�\���:�X_��^K>���'�������qv���}I��F�T����u�s6n��q^�����q�&����a�:&��Ԥ����.aj�qT�A��|�Q��S���޺�9 �=
�,��/��a7�&������G!���S�� �g������k�?���?���O`7��b(��,�+��E`y7����?w�������O&ȝ�_-�w[<"����s��N���f�"�?�@f������?&�O@�G �G����E!�~g��_&�]��
��������X�!7��a��\P������Š�#|������?�z�B��q�SG`3zi�7��(��=�/�1�\��V �V��~��H?�+�i�����67���v�u������~�'6��̞�i�\�{���#5�GN�e��;]��y��Xo�4m�fyW3�З�� ٰjN�3WT,G��IZ��|k����S��j��u8�vlJe~Rf�H��;V����\n�)+��g��ܯ�e��qZ�f�����Npld�r=�����(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c�g�����sC����"�y��#���������E���0
�)
�����`�?���������0��r�ϻ)�?��+�S�N(��9 ����!�?7|)������W���n�m6�9�T�(kԞ��������q,Y���Awݝ��e
T�����zwb�p
Ȟ�T	�Y�몎��VQ�;l��C�+���E�谭���6v�2�QB��
ww�P_�d�5�� I� �J ��Q� f�+[��l����2{�G��mH�� �3	��-����9`5����܎4+����=�ro��v�F�e͜��N����3
���;뿀�W&�]�}X<�xL@������_���?V���@q������VӤU]�UUcY�4¤0�&5�"L���5��uS�4)��ڨUbI��÷����(��[������\�s�,��CzU�5_���H�y�wT|5��b�U̵ḥZ����|���y�ʺ�B[��{k�� Қ�c۷*��9�
}�:Dyu���9J�y9m��x&�f��I |�a�~4��?�E����3?�����@�� �"����B�?������e�$̻)E����������~3�W�֓]bH]��t�u�a���?G}.v�����C�D�ƣ��~�l���A�o5��G��0�fXe�hb�.OＯ�_1��������ن�ɍ7�9;z$��ע��M���?�������
 �B�A�Wn��/����/�����y����E�U�������������e�>=�=%��j�w�w�����/5 �S�}[ r]�u@ym�{u#��NU�e�a��b�agx��UM_ۢ1�u�D>Ր5Z�W�*�hz8F�[�*���<Sj�����5����u�͊���Oe��<Ne�F�E�q��*7�9���6N�C��E.n�� �
�'��G�qӯV%/kJU�y=b]s[��KSҾ�a1�\�<���*��(�Ѭ3e�;ԧBz.7>�[}ԋ�gƁ�G�&���@i_�yf"�=�[�
1fOkq�#s�V��j!$O�u�ע�M��AhN�֚���_��� ��k��N0�i���q����f������cd��>���+��t�ᕒF�FF��K���ӧ���IuF=�� *�,7����(�ﱣ�/?��u�r\tLO�����1J��/�{�
R�1���m������V_��>���Y��OZ����۪�����H.�e������ec�-]_���u�˖b>�o��}�ӧ$��<�����/������O�i�<�o���9���� �(	G'*m���aT2�`�������&}b\�[�OHhD�w�!}��Z)����#9r��m�R�����J�������T�H^�ʱ���aw<�����﷟J��S��,��2y��y~˯�	~���s� ˄������μ=������)-��������w��>c5is�'�6��2���(E�����x���~k^�/,�vB^����*m�
>��KN�ҧ�:���������/��Q�������� �noK?�z��ߐpc���M��B�����.��\���|���m`������K��ﶥ;1�1�%$�9��͍������=�N/V�:��]R��n�铻x�����@x�������w;�,=wT7�!�Ô�.�~�I�?}Uì��}�}~�/]Y��~zB����   @������ � 