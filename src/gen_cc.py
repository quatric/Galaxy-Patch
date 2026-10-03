"""Build the Classic Controller feature for one region from XML and retail DOL."""
import os
import sys
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..', 'tools'))
from ops import Blob, Feature, Patch

XML_FILES = {
    'RMGE01': 'SMG-ClassicController-NTSCU.xml',
    'RMGP01': 'SMG-ClassicController-PAL.xml',
    'RMGJ01': 'SMG-ClassicController-NTSCJ.xml',
    'RMGK01': 'SMG-ClassicController-NTSCK.xml',
}


def build(region, dol):
    xml_name = XML_FILES[region]
    xml_path = os.path.join(HERE, 'cc_xml', xml_name)
    tree = ET.parse(xml_path)
    root = tree.getroot()
    mem_patches = root.findall('.//patch[@id="ccnvidia"]/memory')

    ops = []
    for p in mem_patches:
        addr = int(p.get('offset'), 16)
        new_bytes = bytes.fromhex(p.get('value'))
        orig_hex = p.get('original')
        if addr >= 0x80300000:
            if orig_hex:
                orig_bytes = bytes.fromhex(orig_hex)
            else:
                orig_bytes = dol.read(addr, len(new_bytes))
            ops.append(Patch(addr, new_bytes, orig_bytes, f'In-DOL CC hook at 0x{addr:08X}'))
        else:
            ops.append(Blob(addr, new_bytes, f'CC low-memory routine at 0x{addr:08X}'))

    return Feature('cc', 'Classic Controller', region, ops)
